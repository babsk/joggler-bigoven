function findNode(node, nodeName)
{
  if (node.nodeName==nodeName)
    return node;
  for (var i=0; node.childNodes && i<node.childNodes.length; i++)
  {
    var foundNode=findNode(node.childNodes[i], nodeName);
    if (foundNode!=null)
     return foundNode;
  }
  return null;
}