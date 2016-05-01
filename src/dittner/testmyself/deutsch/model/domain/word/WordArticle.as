package dittner.testmyself.deutsch.model.domain.word {
public class WordArticle {
	public static const UNDEFINED:String = "";
	public static const DER:String = "der";
	public static const DIE:String = "die";
	public static const DAS:String = "das";
	public static const DER_DIE:String = "der/die";
	public static const DER_DAS:String = "der/das";
	public static const DIE_DAS:String = "die/das";
	public static const DER_DIE_DAS:String = "der/die/das";

	public static const ARTICLES:Array = [UNDEFINED, DER, DIE, DAS, DER_DIE, DER_DAS, DIE_DAS, DER_DIE_DAS];
}
}
