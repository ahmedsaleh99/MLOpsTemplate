#!/usr/bin/env sh
set -eu

prog_name=$(basename "$0")
usage() {
  cat <<EOF
Usage: $prog_name <prod|dev|docker> ENV_NAME ENV_FILE

Modes:
  prod    remove and create conda environment from ENV_FILE
  dev     update conda environment from ENV_FILE and install pre-commit
  docker  update conda environment from ENV_FILE (no pre-commit) only to build Docker images.
Environment variables supported: CONDA_EXE, CONDA_ENV_NAME, ENV_FILE
EOF
  exit 2
}

if [ "$#" -lt 1 ]; then
  usage
fi

mode=$1
shift

if [ -n "$1" ]; then
  env_name="$1"
elif [ -n "$CONDA_ENV_NAME" ]; then
  env_name="$CONDA_ENV_NAME"
else
  env_name=""
fi


if [ -n "$2" ]; then
  file="$2"
else
  file="$ENV_FILE"
fi

echo "[install_env] mode=$mode env_name=$env_name file=$file"



remove_env() {
  echo "[install_env] Deactivating any active conda environment..."
  echo "[install_env] Checking if environment '$env_name' exists..."
  conda deactivate 
  if conda env list | awk '{print $1}' | grep -qx "$env_name"; then
    echo "[install_env] Removing environment '$env_name'..."
    if conda env remove -n "$env_name" -y --quiet; then
      echo "[install_env] Environment '$env_name' removed successfully."
    else
      echo "[install_env] Failed to remove environment '$env_name' (continuing)."
    fi
  else
    echo "[install_env] Environment '$env_name' does not exist, skipping removal."
  fi
}


create_env() {
  echo "[install_env] Creating environment $env_name from $file..."
  conda env create -n "$env_name" --file "$file" -q
  echo "[install_env] Environment '$env_name' created successfully"
  echo "[install_env] To activate: conda activate $env_name"
}

update_dev() {
  echo "[install_env] Updating development dependencies into '$env_name' from $file..."
  conda env update -n "$env_name" --file "$file" -q
  echo "[install_env] Development dependencies installed"

}

install_precommit() {
  echo "[install_env] Installing pre-commit into $env_name"
  conda run -n "$env_name" pre-commit install;
}

case "$mode" in
  prod)
    remove_env
    create_env
    ;;
  dev)
    update_dev
    install_precommit
    ;;
  docker)
    update_dev
    ;;
  *)
    echo "Unknown mode: $mode" >&2
    exit 2
    ;;
esac

echo "[install_env] done"
