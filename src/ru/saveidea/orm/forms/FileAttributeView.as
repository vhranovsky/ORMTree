package ru.saveidea.orm.forms {
	
	import com.bit101.components.Label;
	import ru.saveidea.orm.AccessorProperties;

	import com.bit101.components.PushButton;

	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.FileReference;

	/**
	 * @author antonsidorenko
	 */
	public class FileAttributeView extends LabeledAttributeView {
		
		private var browse : PushButton;
		public var file : FileReference;
		
		private var currentFile : Label;
		private var deleteFile : PushButton;

		public function FileAttributeView(accessorProperties : AccessorProperties) {
			super(accessorProperties);

			browse = new PushButton();
			browse.label = "Browse";
			browse.x = panel.width - _padding - browse.width;
			browse.y = panel.height / 2 - browse.height / 2;
			addChild(browse);
			
			currentFile = new Label();
			currentFile.autoSize = true;
			addChild(currentFile);
			
			deleteFile = new PushButton();
			deleteFile.label = "Delete File";
			deleteFile.addEventListener(MouseEvent.CLICK, onDeleteClickHandler);
			addChild(deleteFile);
			
			browse.y = currentFile.y = deleteFile.y = panel.height / 2 - browse.height / 2;

			browse.addEventListener(MouseEvent.CLICK, onBrowseClickHandler);
		}

		private function onDeleteClickHandler(event : MouseEvent) : void {
			
		}

		private function onBrowseClickHandler(event : MouseEvent) : void {
			file = new FileReference();
			file.addEventListener(Event.SELECT, onFileSelectHandler);
			file.browse();
		}
		
		override public function set width(value : Number) : void {
			super.width = value;
			
			update();
		}

		private function update() : void {
			browse.x = panel.width - _padding - browse.width;
			currentFile.x = 100;
			deleteFile.x = currentFile.x+currentFile.textField.width+5;
			trace("updated");
		}

		private function onFileSelectHandler(event : Event) : void {
			// file
			currentFile.text = file.name;
			update();
		}

		override public function set value(value : Object) : void {
			super.value = value;
			
			trace("FileAttributeView.value=",value);
			
			currentFile.text = value as String;
			update();
		}

	}
}