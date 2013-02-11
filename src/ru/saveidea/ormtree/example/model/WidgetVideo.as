package ru.saveidea.ormtree.example.model {
	import ru.saveidea.ormtree.example.model.Widget;

	/**
	 * @author antonsidorenko
	 */
	
	[Bindable]
	public class WidgetVideo extends Widget {
		
		[Mapped]
		public var title : String;
		
		public function toString() : String {
			return title;
		}
		
	}
}