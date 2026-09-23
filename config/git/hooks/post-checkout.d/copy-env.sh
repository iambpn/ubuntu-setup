#!/bin/bash

common_git_dir=$1
is_bare_repository=$2
target_worktree="$(git rev-parse --show-toplevel 2>/dev/null)" || exit 0
target_env="$target_worktree/.env"
[[ -e $target_env || -L $target_env ]] && exit 0

copy_env() {
	local source_env=$1

	if [[ -f $source_env ]]; then
		if cp -- "$source_env" "$target_env"; then
			printf 'Copied .env from %s\n' "${source_env%/.env}"
		else
			printf 'Could not copy %s to %s\n' "$source_env" "$target_env" >&2
		fi
		exit 0
	fi
}

# A bare repository keeps its shared .env beside HEAD and objects. A regular
# repository keeps it in its main worktree, which is first in this list.
if [[ $is_bare_repository == true ]]; then
	copy_env "$common_git_dir/.env"
fi

# If the preferred location has no .env, use the first registered worktree
# that has one. --porcelain -z preserves spaces and special characters.
while IFS= read -r -d '' field; do
	case $field in
		worktree\ *)
			candidate_worktree=${field#worktree }
			[[ $candidate_worktree == "$target_worktree" ]] || copy_env "$candidate_worktree/.env"
			;;
	esac
done < <(git worktree list --porcelain -z 2>/dev/null)

exit 0
