//////////////////////////////////////////////////////////
// Copyright (c) 2009 Grant Skinner
// Released under the MIT License:
// http://www.opensource.org/licenses/mit-license.php
///////////////////////////////////////////////////////////////////

package neatfx.utils {

	public final class StringUtils {

		public static function pad(str:*, cols:uint, char:String = " ", lpad:Boolean = false):String {
			str = String(str);
			if (str.length > cols){
				return str.substr(0, cols);
			}
			while (str.length < cols){
				str = lpad ? char + str : str + char;
			}
			return str;
		}
	}
}