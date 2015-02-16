#  --------------------------------------------------
			t2=re.sub(re.compile('>\n\*\*\*'),'\n',''.join(temp))


# Untitled  -----------------------------------------
					running=True
				elif '***' in i:
					print 'restarting'
					temp.append(i)
					running=True
			if self.getTitle==True:
				self.title=i
				break
			if len(self.body)>0 and self.title=="":
				if '===' in i:
					self.getTitle=True


