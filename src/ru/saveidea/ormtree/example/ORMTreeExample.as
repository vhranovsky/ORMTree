package ru.saveidea.ormtree.example {
	import ru.saveidea.ormtree.example.model.Element;
	import ru.saveidea.base.Document;
	import ru.saveidea.ormtree.example.model.CourseModel;
	import ru.saveidea.ormtree.example.model.SceneModel;
	import ru.saveidea.ormtree.view.ORMTreeView;

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

			var ormTreeView : ORMTreeView = new ORMTreeView();
			addChild(ormTreeView);

			ormTreeView.data = c;
		}

		private function makeSceneModel(title : String) : SceneModel {
			var sm : SceneModel = new SceneModel();
			sm.title = title;
			return sm;
		}
	}
}
