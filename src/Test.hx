import Build.GENERATED_DIR;
import sys.FileSystem;
import sys.io.File;

using StringTools;

// ported and adapted from https://github.com/Microsoft/TypeScript-TmLanguage
private inline final BASELINES_DIR = "baselines";

function main() {
	var hasError = false;
	for (file in FileSystem.readDirectory(GENERATED_DIR)) {
		final generatedText = File.getContent('$GENERATED_DIR/$file');
		final baseline = '$BASELINES_DIR/$file';
		if (!FileSystem.exists(baseline)) {
			hasError = true;
			Sys.println('Warning: "$file" has no baseline.');
			continue;
		}
		final baselinesText = File.getContent(baseline);
		if (removeNewlines(generatedText) != removeNewlines(baselinesText)) {
			hasError = true;
			Sys.println('Error: "$file" is not the same as the baseline!');
		}
	}

	Sys.println(" \n" + if (hasError) "Failed!" else "Success.");
	if (hasError) {
		Sys.exit(1);
	}
}

private function removeNewlines(text:String):String {
	return text.replace('\r\n', '').replace('\n', '');
}
