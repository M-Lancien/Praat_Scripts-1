# This Praat script will process add tiers of all TextGrid files 
# in a given directory and save new files to another directory.
# (See the Praat manual for details on modify tiers.)
# 
# This script is distributed under the GNU General Public License.
# Copyright 2020.04.17 feelins[feipengshao@163.com] 

# 1. several tiers split by [blank];
# 2. each tier can be given a position like 2(hello), means add a tier named "hello" on position 2;if not, then it will add at bottom;
# 3. each tier can be chosen interval or point, like 3(good|), means add a point tier(with mark "|") on position 3;

form dialogue
	sentence input_directory E:\Praat_Scripts\Tiers\old_TextGrid\
	sentence output_directory E:\Praat_Scripts\Tiers\new_TextGrid\
	sentence add_option hello good morning|
endform

if (praatVersion < 6001)
	printline Requires Praat version 6.0 or higher. Please upgrade your Praat version 
	exit
endif
	
Create Strings as file list: "fileList", input_directory$ + "*.TextGrid"
numOfFiles = Get number of strings
for ifile from 1 to numOfFiles
	selectObject: "Strings fileList"
	fileName$ = Get string: ifile
	Read from file: input_directory$ + fileName$
	objectName$ = selected$("TextGrid", 1)

	# 增加多个层
	if add_option$ <> ""
		tmpAddOptionStr$ =  add_option$
		repeat
			findBlank = index(tmpAddOptionStr$, " ")
			curLength = length(tmpAddOptionStr$)
			formerStr$ = left$(tmpAddOptionStr$, findBlank - 1)
			latterStr$ = right$(tmpAddOptionStr$, curLength - findBlank)
			#pause 'tmpAddOptionStr$'
			#pause 'findBlank', 'curLength', #'formerStr$'#, #'latterStr$'#
			if index(formerStr$, "(") <> 0
				if index(formerStr$, "|") <> 0
					tmpformerStr$ = replace$(formerStr$, "|", "", 0)
					markBefore = index(tmpformerStr$, "(")
					curLengthMark = length(tmpformerStr$)
					numStr$ = left$(tmpformerStr$, markBefore - 1)
					tierName$ = mid$(tmpformerStr$, markBefore + 1, curLengthMark - markBefore - 1)
					tierNum = number(numStr$)
					#pause 'markBefore', 'curLengthMark', #'numStr$'#, #'tierName$'#
					Insert point tier: tierNum, tierName$
				else
					markBefore = index(formerStr$, "(")
					curLengthMark = length(formerStr$)
					numStr$ = left$(formerStr$, markBefore - 1)
					tierName$ = mid$(formerStr$, markBefore + 1, curLengthMark - markBefore - 1)
					tierNum = number(numStr$)
					#pause 'markBefore', 'curLengthMark', #'numStr$'#, #'tierName$'#
					Insert interval tier: tierNum, tierName$
				endif
			else
				curTierNum = Get number of tiers
				curOnlyTierName$ = ""
				if findBlank = 0
					if index(latterStr$, "|") <> 0
						Insert point tier: curTierNum + 1, replace$(latterStr$, "|", "", 0)
					else
						Insert interval tier: curTierNum + 1, latterStr$
					endif
				else
					if index(formerStr$, "|") <> 0
						Insert point tier: curTierNum + 1, replace$(formerStr$, "|", "", 0)
					else
						Insert interval tier: curTierNum + 1, formerStr$
					endif
				endif
			endif
			#pause 'latterStr$'
			tmpAddOptionStr$ = latterStr$
		until findBlank = 0
	endif

	#pause
	Save as text file: output_directory$ + fileName$
	selectObject: "TextGrid " + objectName$
	Remove
endfor
selectObject: "Strings fileList"
Remove
exit over!
