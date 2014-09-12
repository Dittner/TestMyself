package dittner.testmyself.deutsch.model.word {
import dittner.satelliteFlight.message.RequestMessage;
import dittner.satelliteFlight.proxy.SFProxy;
import dittner.testmyself.core.message.NoteMsg;
import dittner.testmyself.core.model.demo.*;
import dittner.testmyself.core.model.note.Note;
import dittner.testmyself.core.model.note.NoteSuite;
import dittner.testmyself.core.model.theme.Theme;

public class WordDemoData extends SFProxy implements IDemoData {
	public function WordDemoData() {}

	public function add():void {
		createAndSendNotes();
	}

	private function createAndSendNotes():void {
		var word:Word;
		var examples:Array;

		/*feelings*/

		word = new Word();
		word.article = WordArticle.DAS;
		word.title = "Böse";
		word.description = "зло, вред; грех; m. дьявол, злой дух";
		word.options = "=";
		sendAddNoteRequest(word, createTheme("Чувство, характер", -1));

		word = new Word();
		word.article = WordArticle.DIE;
		word.title = "Emotionalität";
		word.description = "эмоциональность";
		word.options = "=";
		sendAddNoteRequest(word, createTheme("Чувство, характер", 1));

		word = new Word();
		word.article = WordArticle.DIE;
		word.title = "Geselligkeit";
		word.description = "общительность, коммуникабельность";
		word.options = "=";
		sendAddNoteRequest(word, createTheme("Чувство, характер", 1));

		word = new Word();
		word.article = WordArticle.DAS;
		word.title = "Glück";
		word.description = "счастье, благополучие, удача, успех";
		word.options = "-(e)s";
		examples = [];
		examples.push(createExample("Glück auf den Weg!", "счастливого пути!, в добрый час!"));
		examples.push(createExample("Glück ab!", "счастливого полёта!; счастливой посадки! (у лётчиков) ; счастливого пути!"));
		examples.push(createExample("Glück zu!", "желаю удачи!, смелее! (подбадривание)"));
		examples.push(createExample("Wir haben Glück", "нам повезлом, мы счастливы"));
		sendAddNoteRequest(word, createTheme("Чувство, характер", 1), examples);

		word = new Word();
		word.article = WordArticle.DIE;
		word.title = "Ruhe";
		word.description = "покой, неподвижность; нерабочее положение, спокойствие, отдых";
		word.options = "=";
		sendAddNoteRequest(word, createTheme("Чувство, характер", 1));

		word = new Word();
		word.article = WordArticle.DER;
		word.title = "Sinn";
		word.description = "ощущение, чувство, значение, смысл, сознание, разум, помыслы";
		word.options = "-(e)s, -e";
		examples = [];
		examples.push(createExample("der Sinn wahrer Kultur", "сущность истинной культуры"));
		examples.push(createExample("der Sinn eines Wortes", "смысл [значение] слова"));
		sendAddNoteRequest(word, createTheme("Чувство, характер", 1), examples);

		word = new Word();
		word.article = WordArticle.DAS;
		word.title = "Sorgen";
		word.description = "забота, хлопоты";
		word.options = "-s";
		sendAddNoteRequest(word, createTheme("Чувство, характер", 1));

		word = new Word();
		word.article = WordArticle.DER;
		word.title = "Wunsch";
		word.description = "желание";
		word.options = "-es, Wünsche";
		sendAddNoteRequest(word, createTheme("Чувство, характер", 1));

		/*men*/

		word = new Word();
		word.article = WordArticle.DIE;
		word.title = "Eltern";
		word.description = "родители";
		word.options = "";
		sendAddNoteRequest(word, createTheme("Человек", -1));

		word = new Word();
		word.article = WordArticle.DER;
		word.title = "Familienstand";
		word.description = "семейное положение";
		word.options = "-(e)s, Stände";
		sendAddNoteRequest(word, createTheme("Человек", 2));

		word = new Word();
		word.article = WordArticle.DER;
		word.title = "Feind";
		word.description = "враг, неприятель, противник";
		word.options = "-(e)s, -e";
		sendAddNoteRequest(word, createTheme("Человек", 2));

		word = new Word();
		word.article = WordArticle.DER;
		word.title = "Freund";
		word.description = "друг, товарищ";
		word.options = "-(e)s, -e";
		sendAddNoteRequest(word, createTheme("Человек", 2));

		word = new Word();
		word.article = WordArticle.DER;
		word.title = "Herr";
		word.description = "господин";
		word.options = "-n, -en";
		examples = [];
		examples.push(createExample("Herr seiner Sinne sein", "владеть собой"));
		sendAddNoteRequest(word, createTheme("Человек", 2), examples);

		word = new Word();
		word.article = WordArticle.DER;
		word.title = "Junge";
		word.description = "мальчик";
		word.options = "-n, -n";
		sendAddNoteRequest(word, createTheme("Человек", 2));

		word = new Word();
		word.article = WordArticle.DAS;
		word.title = "Kind";
		word.description = "ребенок, дитя";
		word.options = "-(e)s, -er";
		sendAddNoteRequest(word, createTheme("Человек", 2));

		word = new Word();
		word.article = WordArticle.DER;
		word.title = "Mensch";
		word.description = "человек, индивидуум, народ";
		word.options = "-en, -en";
		examples = [];
		examples.push(createExample("ein braver Mensch", "хороший [порядочный] человек"));
		examples.push(createExample("ein feiger Mensch", "трусливый человек, трус"));
		examples.push(createExample("ein gottloser Mensch", "безбожник"));
		examples.push(createExample("ein kunstsinniger Mensch", "любитель искусства, человек, понимающий искусство"));
		examples.push(createExample("ein natürlicher Mensch", "простой (в обращении) человек"));
		sendAddNoteRequest(word, createTheme("Человек", 2), examples);

		/*adjectives*/

		word = new Word();
		word.article = WordArticle.UNDEFINED;
		word.title = "ehrlich";
		word.description = "честный, порядочный";
		word.options = "";
		sendAddNoteRequest(word, createTheme("Прилагательные", -1));

		word = new Word();
		word.article = WordArticle.UNDEFINED;
		word.title = "klar";
		word.description = "ясный, прозрачный; светлый; осветлённый ";
		word.options = "";
		examples = [];
		examples.push(createExample("ein klarer Himmel", "чистое [безоблачное] небо"));
		examples.push(createExample("eine klare Stimme", "чистый голос"));

		sendAddNoteRequest(word, createTheme("Прилагательные", 3), examples);

		word = new Word();
		word.article = WordArticle.UNDEFINED;
		word.title = "sicher";
		word.description = "безопасный, уверенный, твердый; уверенно, безопасно, твердо";
		word.options = "";
		examples = [];
		examples.push(createExample("die Straßen sind nicht sicher", "на улицах небезопасно"));
		examples.push(createExample("sichere Beweise", "неопровержимые доказательства"));
		examples.push(createExample("in der deutschen Sprache sicher sein", "хорошо знать немецкий язык; хорошо успевать по немецкому языку (об ученике)"));
		examples.push(createExample("sicher leben", "жить обеспеченно"));
		examples.push(createExample("sicher!", "(да) конечно!, безусловно!"));
		examples.push(createExample("er kommt sicher", "он обязательно придёт"));
		sendAddNoteRequest(word, createTheme("Прилагательные", 3), examples);

		word = new Word();
		word.article = WordArticle.UNDEFINED;
		word.title = "ähnlich";
		word.description = "похожий, сходный, подобный";
		word.options = "";
		examples = [];
		examples.push(createExample("und ähnliches (u. ä.), und dem ähnliches (u. d. ä.)", "и тому подобное (и т. п.)"));
		sendAddNoteRequest(word, createTheme("Прилагательные", 3), examples);

		word = new Word();
		word.article = WordArticle.UNDEFINED;
		word.title = "schön";
		word.description = "красивый, прекрасный";
		word.options = "";
		examples = [];
		examples.push(createExample("die schönen Künste", "изящные искусства"));
		examples.push(createExample("die schöne Literatur", "художественная литература, беллетристика"));
		examples.push(createExample("schöne Augen machen", "кокетничать, строить глазки"));
		examples.push(createExample("schöne Worte machen", "льстить"));
		examples.push(createExample("bitte schön!", "пожалуйста, прошу!"));
		sendAddNoteRequest(word, createTheme("Прилагательные", 3), examples);

		word = new Word();
		word.article = WordArticle.UNDEFINED;
		word.title = "fremd";
		word.description = "чужой, незнакомый, иностранный";
		word.options = "";
		sendAddNoteRequest(word, createTheme("Прилагательные", 3));

		/*verbs*/

		word = new Word();
		word.article = WordArticle.UNDEFINED;
		word.title = "gehen";
		word.description = "идти";
		word.options = "";
		examples = [];
		examples.push(createExample("in die Schule gehen", "ходить в школу"));
		examples.push(createExample("aufs Land gehen", "(у)ехать за город"));
		examples.push(createExample("auf Reisen gehen", "отправляться в путешествие"));
		sendAddNoteRequest(word, createTheme("Глаголы", -1), examples);

		word = new Word();
		word.article = WordArticle.UNDEFINED;
		word.title = "laufen";
		word.description = "бежать";
		word.options = "";
		sendAddNoteRequest(word, createTheme("Глаголы", 4));

		word = new Word();
		word.article = WordArticle.UNDEFINED;
		word.title = "fahren";
		word.description = "ездить";
		word.options = "";
		sendAddNoteRequest(word, createTheme("Глаголы", 4));

		word = new Word();
		word.article = WordArticle.UNDEFINED;
		word.title = "spielen";
		word.description = "играть";
		word.options = "";
		sendAddNoteRequest(word, createTheme("Глаголы", 4));

		word = new Word();
		word.article = WordArticle.UNDEFINED;
		word.title = "studieren";
		word.description = "учиться";
		word.options = "";
		sendAddNoteRequest(word, createTheme("Глаголы", 4));

		word = new Word();
		word.article = WordArticle.UNDEFINED;
		word.title = "lesen";
		word.description = "читать";
		word.options = "";
		sendAddNoteRequest(word, createTheme("Глаголы", 4));

		word = new Word();
		word.article = WordArticle.UNDEFINED;
		word.title = "sagen";
		word.description = "сказать, говорить";
		word.options = "";
		sendAddNoteRequest(word, createTheme("Глаголы", 4));

		/*other*/

		word = new Word();
		word.article = WordArticle.UNDEFINED;
		word.title = "zusammen";
		word.description = "вместе, сообща";
		word.options = "";
		sendAddNoteRequest(word, null);

		word = new Word();
		word.article = WordArticle.UNDEFINED;
		word.title = "immer";
		word.description = "всегда, постоянно, вечно";
		word.options = "";
		sendAddNoteRequest(word, null);

		word = new Word();
		word.article = WordArticle.UNDEFINED;
		word.title = "gestern";
		word.description = "вчера";
		word.options = "";
		sendAddNoteRequest(word, null);

		word = new Word();
		word.article = WordArticle.UNDEFINED;
		word.title = "morgen";
		word.description = "завтра";
		word.options = "";
		sendAddNoteRequest(word, null);

		word = new Word();
		word.article = WordArticle.UNDEFINED;
		word.title = "heute";
		word.description = "сегодня";
		word.options = "";
		sendAddNoteRequest(word, null);
	}

	private function createTheme(name:String, id:int):Theme {
		var res:Theme = new Theme();
		res.name = name;
		res.id = id;
		return res;
	}

	private function createExample(title:String, translate:String = ""):Note {
		var res:Note = new Note();
		res.title = title;
		res.description = translate;
		return res;
	}

	private function sendAddNoteRequest(note:Note, theme:Theme, examples:Array = null):void {
		var suite:NoteSuite = new NoteSuite();
		suite.note = note;
		suite.themes = theme ? [theme] : [];
		suite.examples = examples ? examples : [];
		sendRequest(NoteMsg.ADD_NOTE, new RequestMessage(null, null, suite));
	}
}
}
