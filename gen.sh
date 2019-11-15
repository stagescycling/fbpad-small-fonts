#!/bin/bash
set -ue # Strict mode

# Generate fbpad fonts using mkfn_ft

TTF_FONTS=(
    DejaVuLGCSansMono-Bold.ttf
    DejaVuLGCSansMono-Oblique.ttf
    DejaVuLGCSansMono.ttf
    DejaVuSansMono-Bold.ttf
    DejaVuSansMono-Oblique.ttf
    DejaVuSansMono.ttf
)

mkfont() {
  local ttf_font_name="${1:?TTF font file name is required, to read from.}"
  local ttf_font_size="${2:?TTF font size in points is required.}"
  local char_width="${3:?Tinyfont char width in pixels is required.}"
  local char_height="${4:?Tinyfont char height in pixels is required.}"
  local tiny_font_name="${5:?Tinyfont file name is required, to write into.}"

  local ttf_font_horizontal_density="100"
  local ttf_font_vertical_density="100"
  
  ./mkfn_ft \
      -w"$char_width" \
      -h"$char_height" \
      "$ttf_font_name:${ttf_font_size}h${ttf_font_horizontal_density}v${ttf_font_vertical_density}" \
      >"$tiny_font_name" || {
    echo "[gen.sh]: ERROR: Cannot generate Tinyfont file: non-zeroe exit code form ./mkfn_ft: $?." >&2
    exit 1
  }

}

main() {
  mkdir -p ./out || {
    echo "[gen.sh] ERROR: Cannot make output directory \"./out\"." >&2
    exit 1
  }

  local ttf_font
  for ttf_font in "${TTF_FONTS[@]}"
  do
    {
      local font_size="8"
      local char_width="$font_size"
      local char_height="12"
      mkfont "$ttf_font" "$font_size" "$char_width" "$char_height" "out/${ttf_font%.ttf}-${char_width}x${char_height}.tf"
    }

    {
      local font_size="6"
      local char_width="$font_size"
      local char_height="9"
      mkfont "$ttf_font" "$font_size" "$char_width" "$char_height" "out/${ttf_font%.ttf}-${char_width}x${char_height}.tf"
    }

  done
}

main
