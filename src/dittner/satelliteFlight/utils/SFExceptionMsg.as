package dittner.satelliteFlight.utils {
public class SFExceptionMsg {

	public static const DUPLICATE_MODULE:String = "Module with registered name already exists";
	public static const DUPLICATE_CMD:String = "Command is already registered by message";
	public static const DUPLICATE_PROXY:String = "Proxy is already registered by id";

	public static const NO_NAME_FOR_MODULE:String = "No name for module";
	public static const MODULE_NOT_FOUND:String = "Module not found";
	public static const PROXY_NOT_FOUND:String = "Proxy not found";
	public static const MODULE_ROOT_NOT_FOUND:String = "Root module not found. Create it before satellite module instantiation";
	public static const COMMAND_NOT_FOUND:String = "Command not found";

}
}
