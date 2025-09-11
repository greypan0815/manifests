#!/bin/bash
set -euo pipefail

# 設定工作目錄與檔案路徑
WORKDIR="/home/cfh00886277"
BUNDLE="${WORKDIR}/images-from-data-studio-1.7/images-from-data-studio-1.7.tar.gz"
EXTRACT_DIR="${WORKDIR}/images-from-data-studio-1.7"

# 目標 OpenShift 映像倉庫 (依原腳本)
REGISTRY_ROUTE="default-route-openshift-image-registry.apps-crc.testing"
NAMESPACE="kubeflow"

# echo "🔎 檢查壓縮檔: ${BUNDLE}"
# if [ ! -f "${BUNDLE}" ]; then
#   echo "❌ 找不到壓縮檔：${BUNDLE}"
#   exit 1
# fi

# echo "📂 解壓縮到: ${EXTRACT_DIR}"
# tar -xzf "${BUNDLE}" -C "${EXTRACT_DIR}"

cd "${EXTRACT_DIR}"

# 依原腳本列出需載入的 tar 檔名
FILES=(
  "data-studio_centraldashboard:22bf39f.tar"
  "data-studio_api-server:a537a1a.tar"
  "data-studio_beaver-operators-config-synchronizer:1.0.0-ds.tar"
  "product-gui-automlab:1dfd26e.tar"
  "product-gui-mole:1dfd26e.tar"
  "product-gui-tumblebug:0d7f381.tar"
  "product-gui-whale:0d7f381.tar"
)

echo "📦 載入 Docker 映像..."
for f in "${FILES[@]}"; do
  if [ -f "${f}" ]; then
    echo "➡️  docker load -i ${f}"
    docker load -i "${f}"
  else
    echo "⚠️  找不到檔案：${f}，跳過載入"
  fi
done

# 對應來源映像名稱與目標標籤（依原腳本）
declare -A MAP
MAP["kubeflow/data-studio_centraldashboard:22bf39f"]="${REGISTRY_ROUTE}/${NAMESPACE}/centraldashboard:22bf39f"
MAP["kubeflow/data-studio_api-server:a537a1a"]="${REGISTRY_ROUTE}/${NAMESPACE}/api-server:a537a1a"
MAP["kubeflow/data-studio_beaver-operators-config-synchronizer:1.0.0-ds"]="${REGISTRY_ROUTE}/${NAMESPACE}/beaver-operators-config-synchronizer:1.0.0-ds"
MAP["kubeflow/product-gui-automlab:1dfd26e"]="${REGISTRY_ROUTE}/${NAMESPACE}/product-gui-automlab:1dfd26e"
MAP["kubeflow/product-gui-mole:1dfd26e"]="${REGISTRY_ROUTE}/${NAMESPACE}/product-gui-mole:1dfd26e"
MAP["kubeflow/product-gui-tumblebug:0d7f381"]="${REGISTRY_ROUTE}/${NAMESPACE}/product-gui-tumblebug:0d7f381"
MAP["kubeflow/product-gui-whale:0d7f381"]="${REGISTRY_ROUTE}/${NAMESPACE}/product-gui-whale:0d7f381"

echo "🏷️  標籤映像..."
for src in "${!MAP[@]}"; do
  dst="${MAP[$src]}"
  echo "➡️  docker tag ${src} ${dst}"
  docker tag "${src}" "${dst}" || echo "⚠️  標籤失敗（可能未載入）：${src}"
done

echo "🚀 推送映像到 ${REGISTRY_ROUTE} ..."
for src in "${!MAP[@]}"; do
  dst="${MAP[$src]}"
  echo "➡️  docker push ${dst}"
  docker push "${dst}" || echo "⚠️  推送失敗：${dst}"
done

echo "✅ 全部完成"