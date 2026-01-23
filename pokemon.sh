# by discomanfulanito,
# for everyone — as code should be

# Sprites are drawn from here
POKEMON_LIST=(
  victini
  "mimikyu -s"
  celebi
  furret
  "mewtwo --mega-y"
)
# Change with your fetcher
FETCHER="fastfetch --logo none"

FETCHER_HEIGHT=$($FETCHER | wc -l)

# Extra settings
EXTRA_PADDING_H=2
EXTRA_PADDING_W=0

# Room for the sprite
WIDTH=38

# Gets a sprite via pokeget
sprite=$(pokeget ${POKEMON_LIST[RANDOM % ${#POKEMON_LIST[@]}]} --hide-name)

# Gets sprite's height
height=$(echo "$sprite" | wc -l)

# Pad for vertical centering
pad_top=$((($FETCHER_HEIGHT - $height) / 2))
pad_top=$((pad_top + EXTRA_PADDING_H))

# Just for safety
(( pad_top < 0 )) && pad_top=0

# Gets sprite's sprite_width
# strip ANSI color codes with sed to get the true printed width
sprite_width=$(
  printf '%s\n' "$sprite" \
  | sed 's/\x1b\[[0-9;]*m//g' \
  | awk '{ if (length > max) max = length } END { print max }'
)

# Calculate the lateral padding
pad_Left=$((($WIDTH - sprite_width) / 2))
# +1 to avoid odd-width rounding issues so logo area remains visually centered
pad_Right=$((($WIDTH - sprite_width + 1) / 2))

pad_Left=$((pad_Left + EXTRA_PADDING_W))
pad_Right=$((pad_Right + EXTRA_PADDING_W))

# Just for safety
(( pad_Left < 0 )) && pad_Left=0
(( pad_Right < 0 )) && pad_Right=0

# this may not work for your fetcher, check them all
echo "$sprite" | $FETCHER --file-raw - --logo-padding-top $pad_top --logo-padding-left $pad_Left --logo-padding-right $pad_Right
