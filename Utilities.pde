boolean insideBox(float x, float y, float bx, float by, float w, float h) {
  //check if point xy is inside box defined by xy widht height
  if (bx -w/2 < x && x < bx + w/2) {
    if (by-h/2 < y && y < by + h/2) {
      return true;
    }
  }
  return false;
}
