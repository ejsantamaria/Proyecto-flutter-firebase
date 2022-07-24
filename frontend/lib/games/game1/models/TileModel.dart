class TileModel {
  String imageAssetPath;
  bool isSelected;
  
  void setImageAssetPath(String getImageAssetPath){
    imageAssetPath = getImageAssetPath;
  }

  String getImageAssetPath(){
    return imageAssetPath;
  }

  void setIsSelected(bool getIsSelected){
    isSelected = getIsSelected;
  }

  bool getIsSelected(){
    return isSelected;
  }

  TileModel(this.imageAssetPath,this.isSelected );
}