package ru.saveidea.orm.forms {
	import ru.saveidea.orm.DataTypeList;

	import flash.events.Event;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.FileReference;

	/**
	 * @author OldMan
	 * Добавляет функционал для работы с файлами в моделях
	 * FIXME:Сделать, чтобы работа шла с File, а не с FileReference
	 */
	public class ModelForm extends ModelFormBase {
		
		public function ModelForm() {
			super();
		}

		override protected function updateModelAttributeFromView(accessor : XML) : void {
			// super.updateModelAttributeFromView(accessor);

			var attributeView : AttributeView = attributeByName[accessor.attribute("name")];

			if (!attributeView) {
				return;
			}

			if (attributeView.accessorProperties.dataType == DataTypeList.FILE) {
				var fileAttributeView : FileAttributeView = attributeView.getCustomAttributeView() as FileAttributeView;

				// Если был старый файл, его удаляем, новый добавляем и ссылку на него записываем в поле

				if (fileAttributeView.file) {
					if (fileAttributeView.value) {
						// удаляем файл
						

						var file : File = File.applicationStorageDirectory.resolvePath(attributeView.value as String);
						trace("remove old one:",file.nativePath);
						file.deleteFile();
					}

					fileAttributeView.file.addEventListener(Event.COMPLETE, onFileLoadCompleteHandler);
					fileAttributeView.file.load();

					model[accessor.attribute("name")] = "files/" + fileAttributeView.file.name;
				}
			} else {
				model[accessor.attribute("name")] = attributeView.value;
			}
		}

		private function onFileLoadCompleteHandler(event : Event) : void {
			//trace("event.target", event.target);
			var target : FileReference = event.target as FileReference;
			//trace("File load complete", target.name);

			// Файл загружен, кладём его в какую-то директорию
			var file : File = File.userDirectory;
			file = file.resolvePath("files/" + target.name);
			var fileStream : FileStream = new FileStream();
			fileStream.open(file, FileMode.WRITE);
			fileStream.writeBytes(target.data);
			fileStream.addEventListener(Event.CLOSE, fileClosed);
			fileStream.close();
		}

		private function fileClosed(event : Event) : void {
			trace("File closed");
		}
	}
}
