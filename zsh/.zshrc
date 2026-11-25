[[ -n $ZPROF ]] && zmodload zsh/zprof  # profile with: ZPROF=1 zsh -i -c exit; zprof

# Split into ~/.config/zsh/*.zsh, loaded in numeric order
for _f in ~/.config/zsh/*.zsh(N); do
  source $_f
done
unset _f
