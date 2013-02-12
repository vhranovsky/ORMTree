package ru.saveidea.orm {
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;

	/**
	 * @author antonsidorenko
	 */
	public class AirDBEntityManager extends DBEntityManager {
		
		private var _dbStorage : File;
		private static var _instance : AirDBEntityManager;
		private static var _allowToCreateInstance : Boolean = false;
		
		public function AirDBEntityManager() {
			super();
			if (!_allowToCreateInstance) {
				throw new Error("AirDBEntityManager is Singletone, use AirDBEntityManager.instance");
			}
		}
		
		public static function get instance() : AirDBEntityManager {
			
			if (!_instance) {
				_allowToCreateInstance = true;
				_instance = new AirDBEntityManager();
				_allowToCreateInstance = false;
			}
			
			return _instance;
		}

		public function set dbStorage(dbStorage : File) : void {
			_dbStorage = dbStorage;

			if (_dbStorage.exists) {
				// загружаем

				var fileStream : FileStream = new FileStream();
				fileStream.open(_dbStorage, FileMode.READ);
				if (_dbStorage.size>0) {
					setData(fileStream.readUTFBytes(_dbStorage.size));
				}

				debug("File loaded and read");
			} else {
				saveToDisk();

				debug("File Maked");
			}
		}

		public function export() : void {
			var f : File = new File();
			f.save(JSON.stringify(classes),"db");
		}

		override protected function saveToDisk(data : String = "") : void {
			var fileStream : FileStream = new FileStream();
			fileStream.open(_dbStorage, FileMode.WRITE);
			fileStream.writeUTFBytes(data);
			fileStream.close();
			debug("Saved to disk");
		}
	}
}