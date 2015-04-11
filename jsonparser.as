// Adapted from
//
// http://stackoverflow.com/questions/11282702/parse-json-in-as2
// http://stackoverflow.com/questions/4331042/problem-using-json-as
//
// stringify still needs work due to syntax not supported
// by Flash 5
//
// original example coded for AS 2.0 as a class

var ch = ''
var at = 0
var text = ''


function next()
{
   ch = text.charAt(at)
   at +=1
   return ch;
}

function white()
{
   while (ch != null)
   {
      if (ch<= ' ')
      {
         next();
      }
      else if (ch == '/')
      {
         n = next()
         if (n == '/')
         {
            while (next() && ch != '\n' && ch != '\r')
            {
            }
         }
         else if (n == '*')
         {
            next()
            while (true)
            {
               if (ch)
               {
                  if (ch == '*')
                  {
                     if (next() == '/')
                     {
                        next()
                        break;
                     }
                     else
                     {
                        next()
                     }
                  }
               }
               else
               {
                  trace("unterminated comment");
               }
            }
         }
         else
         {
            trace ("SYNTAX ERROR")
         }
      }
      else
      {
         break;
      }
   }
}

function obj()
{
   var k, o = {};

   if (ch == '{') 
   {
      next();
      white();
      if (ch == '}') 
      {
         next();
         return o;
      }
      while (ch != null) 
      {
         k = str();
         white();
         if (ch != ':') 
         {
            break;
         }
         next();
         o[k] = value();
         white();
         if (ch == '}') 
         {
            next();
            return o;
         } 
         else if (ch != ',') 
         {
            break;
         }
         next();
         white();
      }
   }
   trace("Bad object");
}

function arr()
{
   var a = [];

   if (ch == '[') 
   {
                next();
                white();
                if (ch == ']') 
                {
                    next();
                    return a;
                }
                while (ch != null) 
                {
                    a.push(value());
                    white();
                    if (ch == ']') 
                    {
                        next();
                        return a;
                    } 
                    else if (ch != ',') 
                    {
                        break;
                    }
                    next();
                    white();
                }
   }
   trace("Bad array");
}

function str()
{
   var s = ''
   var outer = false;

   if (ch == '"') 
   {
      while (next() != null) 
      {
         if (ch == '"') 
         {
            next();
            return s;
         } 
         else if (ch == '\\') 
         {
            n = next()
            if (n == 'b')
               s += '\b'
            else if (n=='f')
               s += '\f';
            else if (n=='n')
               s += '\n';
            else if (n=='r')
               s += '\r';
            else if (n=='t')
               s += '\t';
            else if (n=='u')
            {
               u = 0;
               for (i = 0; i < 4; i += 1) 
               {
                                t = parseInt(this.next(), 16);
                                if (!isFinite(t)) {
                                    outer = true;
                                    break;
                                }
                                u = u * 16 + t;
                }
                if(outer) 
                {
                   outer = false;
                   break;
                }
                s += String.fromCharCode(u);
             }
             else
                s += ch;
          }
          else 
          {
             s += ch;
          }
       }
    }
    trace("Bad string");
}

function num()
{
   var n = '', v;

   if (ch == '-') 
   {
                n = '-';
                next();
   }

   while (ch >= '0' && ch <= '9') 
   {
                n += ch;
                next();
   }
            
   if (ch == '.') 
   {
                n += '.';
                next();
                while (ch >= '0' && ch <= '9') 
                {
                    n += ch;
                    next();
                }
   }
            

   if (ch == 'e' || ch == 'E') 
   {
                n += ch;
                next();
                if (ch == '-' || ch == '+') 
                {
                    n += ch;
                    next();
                }
                while (ch >= '0' && ch <= '9') 
                {
                    n += ch;
                    next();
                }
   }

   v = Number(n);
   if (!isFinite(v)) 
   {
      trace ("Bad number");
   }
   return v;
}


function word()
{
	// TODO: see below
}

function value()
{
   white()
   if (ch == '{')
      return obj()
   else if (ch == '[')
      return arr()
   else if (ch == '"')
      return str()
   else if (ch == '-')
      return num()
   else
      return ch>='0' && ch<='9' ? num() : word()
}

//
// this is the main entry point
// call this with a JSON string and it will return
// an object with all the appropriately named & typed fields
//
function parse (_text)
{
   text = _text
   at = 0
   ch = ' '
   return value()	
}



// UNUSED STUFF - this was in the original file, but was not required for this implementation
/*
function stringify(arg)
{
   var c, i, l, s = '', v;

   t = typeof arg;


   if (t == 'object')
   {
      if (arg != null) 
      {
         if (false)
         {
 //        if (arg instanceof Array) 
           for (i = 0; i < arg.length; ++i) 
            {
               v = stringify(arg[i]);
               if (s) 
               {
                  s += ',';
               }
               s += v;
            }         
            return '[' + s + ']';
         }
         else if (false)
         {
 //         else if (typeof arg.toString != 'undefined') 
          for (i in arg) 
            {
               v = arg[i];
               if (typeof v != 'undefined' && typeof v != 'function') 
               {
                  v = stringify(v);
                  if (s) 
                  {
                     s += ',';
                  }
                  s += stringify(i) + ':' + v;
                }
             }
             return '{' + s + '}';
         }

      }
      return 'null';
   }
   else if (t == 'number')
      return isFinite(arg) ? String(arg) : 'null';
   else if (t == 'string')
   {
      l = arg.length;
      s = '"';
      for (i = 0; i < l; i += 1) 
      {
         c = arg.charAt(i);
         if (c >= ' ') 
         {
            if (c == '\\' || c == '"') 
            {
               s += '\\';
            }
            s += c;
         } 
         else 
         {
            if (c=='\b')
               s += '\\b';
            else if (c=='\f')
               s += '\\f';
            else if (c=='\n')
               s += '\\n';
           else if (c=='\r')
               s += '\\r';
           else if (c=='\t')
               s += '\\t';
           else
           {
              c = c.charCodeAt();
              s += '\\u00' + Math.floor(c / 16).toString(16) +
                                (c % 16).toString(16);
           }
         }
      }
      return s + '"';
   }
   else if (t == 'boolean')
      return String(arg);
   else
      return 'null';
}
 

function word()
{

           switch (ch) {
                case 't':
                    if (this.next() == 'r' && this.next() == 'u' &&
                            this.next() == 'e') {
                        this.next();
                        return true;
                    }
                    break;
                case 'f':
                    if (this.next() == 'a' && this.next() == 'l' &&
                            this.next() == 's' && this.next() == 'e') {
                        this.next();
                        return false;
                    }
                    break;
                case 'n':
                    if (this.next() == 'u' && this.next() == 'l' &&
                            this.next() == 'l') {
                        this.next();
                        return null;
                    }
                    break;
            }
            this.error("Syntax error");
}
*/

