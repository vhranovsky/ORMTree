package ru.saveidea.ormtree.example.admin {
	import ru.saveidea.ormtree.manager.ORMTreeManager;
	import ru.saveidea.ormtree.view.ORMTreeNodeView;
	import ru.saveidea.orm.forms.ModelForm;
	import ru.saveidea.tree.view.TreeNodeViewBase;
	import ru.saveidea.offline.FileLoader;
	import ru.saveidea.orm.AirDBEntityManager;
	import ru.saveidea.tree.manager.TreeManager;
	import ru.saveidea.view.ManualSizedSprite;

	import flash.events.Event;
	import flash.filesystem.File;

	/**
	 * @author antonsidorenko
	 */
	public class AirClientAdminPanel extends ManualSizedSprite {
		
		private var header : Header;
		public var treeManager : ORMTreeManager;
		private var _data : Object;
		private var em : AirDBEntityManager = AirDBEntityManager.instance;
		private var dbFile : File;
		private var dbFileName : String;
		private var rootModelClass : Class;
		private var useFullScreen : Boolean = true;

		public function AirClientAdminPanel(rootModelClass : Class, dbFileName : String = "db", title : String = "Панель Администратора") {
			this.rootModelClass = rootModelClass;
			this.dbFileName = dbFileName;

			header = new Header(title);
			addChild(header);

			treeManager = new ORMTreeManager(ORMTreeNodeView, ModelForm);
			treeManager.y = 50;
			addChild(treeManager);

			addEventListener(Event.ADDED_TO_STAGE, onAddedToStageHandler);
		}

		private function onAddedToStageHandler(event : Event) : void {
			stage.addEventListener(Event.RESIZE, onStageResizeHandler);
			onStageResizeHandler(null);

			setUp();
		}

		private function onStageResizeHandler(event : Event) : void {
			if (useFullScreen) {
				header.width = stage.stageWidth;
				treeManager.width = stage.stageWidth;
				treeManager.height = stage.stageHeight - 50;
			} else {
				header.width = width || stage.stageWidth;
				treeManager.width = width || stage.stageWidth;
				treeManager.height = height - 50 || stage.stageHeight - 50;
			}
		}

		override public function set height(value : Number) : void {
			super.height = value;

			useFullScreen = false;
		}

		public function setUp() : void {
			dbFile = File.applicationStorageDirectory.resolvePath(dbFileName);
			trace("dbfile url:", dbFile.url);

			if (!dbFile.exists) {
				trace("File is founded");
				// берём файл по умолчанию и сохраняем его!
				em.dbStorage = dbFile;
				FileLoader.loadText("db", onDBLoadHandler);
			} else {
				em.dbStorage = dbFile;
				init();
			}
		}

		private function onDBLoadHandler(db : String) : void {
			em.setData(db);
			em.save();
			init();
		}

		private function init() : void {
			var rootModel : Object;
			
			if (em.findAll(rootModelClass).length == 0) {
				rootModel = new rootModelClass();
			} else {
				rootModel = em.findAll(rootModelClass)[0];
			}
			
			data = rootModel;
		}

		public function set data(data : Object) : void {
			_data = data;

			treeManager.data = data;
		}
	}
}