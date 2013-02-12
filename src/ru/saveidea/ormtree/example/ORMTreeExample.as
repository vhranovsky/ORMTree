package ru.saveidea.ormtree.example {
	import ru.saveidea.base.Document;
	import ru.saveidea.ormtree.example.admin.AirClientAdminPanel;
	import ru.saveidea.ormtree.example.model.CourseModel;
	import ru.saveidea.ormtree.example.model.Element;
	import ru.saveidea.ormtree.example.model.SceneModel;
	import ru.saveidea.ormtree.view.ORMTreeNodeView;
	import ru.saveidea.tree.manager.TreePanel;
	import ru.saveidea.tree.view.TreeView;
	import ru.saveidea.tree.view.TreeViewEvent;

	/**
	 * @author antonsidorenko
	 */
	public class ORMTreeExample extends Document {
		
		public function ORMTreeExample() {
			super();

			var c : CourseModel = new CourseModel();
			c.title = "Course!!!";

			var m : SceneModel = makeSceneModel("Scene 0");
			var m2 : SceneModel = makeSceneModel("Scene 1");

			c.scenes.addItem(m);
			c.scenes.addItem(m2);

			var e : Element = new Element();

			m.elements.addItem(e);

			// var ormTreeView : ORMTreeView = new ORMTreeView();
			// addChild(ormTreeView);

			// ormTreeView.data = c;
			
			var ap : AirClientAdminPanel = new AirClientAdminPanel(CourseModel);
			addChild(ap);
			
			return;
			
			var p : TreePanel = new TreePanel(ORMTreeNodeView);
			addChild(p);
			
			p.data = c;
			return;

			var t : TreeView = new TreeView(ORMTreeNodeView);
			t.addEventListener(TreeViewEvent.NODE_SELECT, trace);
			t.addEventListener(TreeViewEvent.NODE_ADD, trace);
			addChild(t);

			t.data = c;
		}

		private function makeSceneModel(title : String) : SceneModel {
			var sm : SceneModel = new SceneModel();
			sm.title = title;
			return sm;
		}
	}
}
