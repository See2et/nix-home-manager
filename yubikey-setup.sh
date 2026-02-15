#!/usr/bin/env bash
set -euo pipefail

BUSID="${1:-1-9}"          # 例: 1-9
REMOTE="${2:-}"            # 例: 172.21.96.1（省略時は default gateway を自動推定）

VIDPID_REGEX="1050:0407"   # あなたのログのYubiKey（必要なら変更）
LSUSB_MATCH_REGEX="Yubico\.com|Yubikey|${VIDPID_REGEX}"

need_cmd() {
  command -v "$1" >/dev/null 2>&1 || {
    echo "error: '$1' が見つかりません。必要パッケージを導入してください。" >&2
    exit 127
  }
}

# rootが必要な操作だけsudoを使う
SUDO=""
if [[ "${EUID:-$(id -u)}" -ne 0 ]]; then
  SUDO="sudo"
fi

need_cmd lsusb
need_cmd ip
need_cmd awk
need_cmd ykman
need_cmd usbip
need_cmd modprobe

echo "== lsusb =="
lsusb || true

# 既に見えているなら attach をスキップ（ここが一番重要）
if lsusb | grep -Eiq "${LSUSB_MATCH_REGEX}"; then
  echo "info: YubiKey が既にWSL側で認識されています。usbip attach はスキップします。"
else
  echo "== modprobe vhci_hcd =="
  ${SUDO} modprobe vhci_hcd || true

  if [[ -z "${REMOTE}" ]]; then
    REMOTE="$(ip route | awk '/default/ {print $3; exit}')"
  fi
  echo "info: remote(host Windows) = ${REMOTE}"

  echo "== usbip list --remote=${REMOTE} (export確認) =="
  usbip list --remote="${REMOTE}" || true

  echo "== usbip attach --remote=${REMOTE} --busid=${BUSID} =="
  set +e
  ATTACH_OUT="$(${SUDO} usbip attach --remote="${REMOTE}" --busid="${BUSID}" 2>&1)"
  ATTACH_RC=$?
  set -e

  if [[ ${ATTACH_RC} -ne 0 ]]; then
    echo "${ATTACH_OUT}" >&2
    if echo "${ATTACH_OUT}" | grep -qi "Device busy (exported)"; then
      echo "warn: Device busy (exported) = 既に他クライアント/別手順でアタッチ済みの可能性が高いので継続します。"
      # 状態確認
      echo "== usbip port =="
      usbip port || true
    else
      echo "error: usbip attach に失敗しました。Windows側で usbipd bind 済みか、既に別のWSLにattachしていないか確認してください。" >&2
      exit ${ATTACH_RC}
    fi
  fi

  echo "== lsusb (after attach) =="
  lsusb || true
fi

echo "== ykman info =="
ykman info

