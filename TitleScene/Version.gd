extends Label

func _ready():
	var v = $"/root/Version"
	var YYYYMMDDHHMMSS = v.YYYYMMDDHHMMSS
	var GIT_HASH = v.GIT_HASH
	var GIT_CLEAN = v.GIT_CLEAN

	var GIT_HASH_8 = 'dev' if v.GIT_HASH=='dev' else \
					 v.GIT_HASH.right(v.GIT_HASH.length()-8)
	var GIT_DIRTY_MARK = '' if v.GIT_CLEAN else '#'

	text = 'build {t}({h}{m})'.format({'t':YYYYMMDDHHMMSS,'h':GIT_HASH_8,'m':GIT_DIRTY_MARK})
