package alternativa.tanks.bonuses 
{
	import alternativa.engine3d.loaders.Parser3DS;
    import alternativa.engine3d.materials.TextureMaterial;
    import alternativa.engine3d.objects.Mesh;
    import flash.display.BitmapData;
    import flash.utils.ByteArray;
	/**
	 * ...
	 * @author TLVK official
	 */
	public class BonusSkin 
	{
		public var cordsTexture:BitmapData = null;
		public var parachuteTexture:BitmapData = null;
		public var parachuteMesh:Mesh = null;
		public var parachuteInnerTexture:BitmapData = null;
		public var parachuteInnerMesh:Mesh = null;
        public var boxTexture:BitmapData = null;      
        public var boxMesh:Mesh = null;
      
		public function BonusSkin(box:Mesh, boxTexture:BitmapData, parachuteCords:BitmapData, parachuteMesh:Mesh, parachuteInnerMesh:Mesh, parachuteTexture:BitmapData, parachuteInnerTexture:BitmapData) 
		{
			this.boxMesh = box;
			this.boxTexture = boxTexture;
			this.cordsTexture = parachuteCords;
			this.parachuteMesh = parachuteMesh;
			this.parachuteInnerMesh = parachuteInnerMesh;
			this.parachuteTexture = parachuteTexture;
			this.parachuteInnerTexture = parachuteInnerTexture;
		}
		
	}

}