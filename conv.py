import sys
fname='Lecture1_2015/p1.Rpres'

class Page:
	
	def __init__(self,fname):

		self.getContent(fname)
		self.slides=[]
		self.getAllSlides()
		self.fname=fname
		self.printToFile()


	def getContent(self,fname):
		with open(fname) as f:
			temp= f.readlines()
			# cut breaks:
			import re
			t2=re.sub(re.compile('>\n\*\*\*'),'\n',''.join(temp))
			t2=re.sub(re.compile('```\n(.|\n)[^=]*?\*\*\*+\n```\{r\}'),'',''.join(t2))
			t2=re.sub(re.compile('```\n\*\*\*+(.|\n)[^=]*```\{r\}'),'',''.join(t2))
			# t2=re.sub(re.compile('```\n\*\*\*+\n```\{r\}'),'',''.join(t2))
			print 'CUTHERE' in t2
			self.content=[i+'' for i in t2.split('\n')]
		f.close()

	def getOneSlide(self):
		slide=Slide(self.content)
		self.content=slide.content
		self.slides.append(slide)

	def getAllSlides(self):
		while len(self.content)>1:
			self.getOneSlide()

	def printToFile(self):
		fn=self.fname.split('.')[0]+'.R'
		output=open(fn,"wb")
		for slide in reversed(self.slides):
			output.write("# {0} {1}".format(slide.title,'-'*(50-len(slide.title)))+'\n')
			output.write('\n'.join(reversed(slide.body))+'\n\n\n')
		output.close()



class Slide:
	
	def __init__(self,text):
		self.content=text
		self.count=0
		self.body=[]
		self.getTitle=False
		self.title=""
		self.getText()
		self.setText()

	def getText(self):
		running=False	
		temp=[]	
		for i in reversed(self.content):
			self.count+=1
			if len(self.body)==0:
				if '```' in i and running==True:
					if 'setup' not in i:
						self.body=temp
						continue
					else:
						break
				elif running ==True:
					temp.append(i)
				elif '```' in i and running==False:
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
				if '```' in i:
					self.title='Untitled '
					break

	def setText(self):
		self.content=self.content[0:-self.count]

p=Page(fname)

def main(argv=None):#take input file
	import sys
	if argv is None:
		argv =sys.argv
	print argv
	

	if len(argv)>=2:
   		fname=argv[1]
   		print fname
		Page(fname)
	else: 
		print """
	Welcome to the Rpres -> R converter. 
	The script will take an input Rpres file and output an 
	R script in the same directory, with the same prefix.
	Please enter the file to convert as follows:

	python conv myfile.Rpres
		"""


if __name__ == "__main__":
	sys.exit(main())
