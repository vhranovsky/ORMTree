package ru.saveidea.ormtree.view {
	import ru.saveidea.tree.view.TreeNodeViewIcons;

	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.getTimer;

	/**
	 * @author antonsidorenko
	 */
	public class ORMTreeNodeSkin extends TreeNodeSkinBase {
		
		protected var textfield : TextField;
		private var dtf : TextFormat;
		private var container : Sprite;
		private var folderIcon : TreeNodeViewIcons;
		private var lastClickTime : uint;

		public function ORMTreeNodeSkin(view : TreeNodeViewBase) {
			super(view);

			folderIcon = new TreeNodeViewIcons();
			folderIcon.gotoAndStop(1);

			textfield = new TextField();

			container = new Sprite();
			addChild(container);

			dtf = new TextFormat("Arial", 13, 0);
			textfield.defaultTextFormat = dtf;

			textfield.autoSize = TextFieldAutoSize.LEFT;
			textfield.multiline = true;
			textfield.wordWrap = true;
			textfield.width = 180;
			textfield.x = folderIcon.x + 16 + 2;
			textfield.mouseEnabled = false;

			view.childsContainer.x = textfield.x;
			view.childsContainer.y = textfield.height + 2;

			folderIcon.buttonMode = true;
			folderIcon.addEventListener(MouseEvent.CLICK, onIconClickHandler);
			folderIcon.y = 20 / 2 - 16 / 2;

			addChild(folderIcon);
			addChild(textfield);

			addEventListener(MouseEvent.CLICK, onClickHandler);
		}

		private function onDoubleClickHandler(event : MouseEvent) : void {
			if (view.isCollapsed) {
				view.expand();
			} else {
				view.collapse();
			}
			updateIconCollapseState();
		}

		private function getTitle() : String {
			if (data is ORMTreeNodeData) {
				return (data as ORMTreeNodeData).label;
			} else {
				return String(data);
			}
			
			return null;
		}

		override public function changeState(state : String) : void {
			super.changeState(state);

			if (state == TreeNodeViewBase.STATE_SELECTED) {
				// полоску рисуем
				container.graphics.clear();
				container.graphics.beginFill(0x3875d7);
				container.graphics.drawRect(-100, 0, 500, textfield.height);
				container.graphics.endFill();

				dtf.color = 0xffffff;
				textfield.defaultTextFormat = dtf;
				textfield.text = getTitle();
			} else if (state == TreeNodeViewBase.STATE_NORMAL) {
				// полоску убираем
				container.graphics.clear();
				dtf.color = 0;
				textfield.defaultTextFormat = dtf;
				textfield.text = getTitle();
				// textfield.transform.colorTransform.color = 0xffffff;
			}
		}

		private function onClickHandler(event : MouseEvent) : void {
			event.stopPropagation();
			if (getTimer() - lastClickTime < 180) {
				onDoubleClickHandler(null);
			}
			view.select();
			lastClickTime = getTimer();
		}

		private function onIconClickHandler(event : MouseEvent) : void {
			if (view.childsContainer.numChildren > 0) {
				if (view.isCollapsed) {
					view.expand();
				} else {
					view.collapse();
				}
			}
			updateIconCollapseState();
		}

		override public function update() : void {
			super.update();

			if (view.childsContainer.numChildren > 0) {
				folderIcon.visible = true;
			} else {
				folderIcon.visible = false;
			}

			textfield.text = getTitle();
			view.childsContainer.y = textfield.height + 2;

			updateIconCollapseState();
		}

		private function updateIconCollapseState() : void {
			if (view.isCollapsed) {
				folderIcon.gotoAndStop(1);
			} else {
				folderIcon.gotoAndStop(2);
			}
		}
	}
}