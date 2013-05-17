part of ice;

class Full {
  Element el;
  Editor _ice;

  Full({enable_javascript_mode: true}) {
    el = new Element.html('<div id=ice>');
    document.body.nodes.add(el);

    _attachToolbar();
    _fullScreenStyles();
    _ice = new Editor('#ice', enable_javascript_mode: enable_javascript_mode);

    editorReady.then((_)=> _applyStyles());
  }

  Future get editorReady => _ice.editorReady;

  _attachToolbar() {
    var toolbar = new Element.html('<div class=ice-toolbar>');
    toolbar.style
      ..position = 'absolute'
      ..top = '10px'
      ..right = '20px'
      ..zIndex = '999';

    _attachMenuButton(toolbar);

    el.children.add(toolbar);
  }

  _attachMenuButton(parent) {
    var el = new Element.html('<button>☰</button>');
    parent.children.add(el);

    el.onClick.listen((e)=> this.toggleMenu());
  }

  toggleMenu() {
    if (queryAll('.ice-menu').isEmpty) _showMenu();
    else _hideMenu();
  }

  _showMenu() {
    var menu = new Element.html('<ul class=ice-menu>');
    el.children.add(menu);

    menu.style
      ..position = 'absolute'
      ..right = '17px'
      ..top = '55px'
      ..zIndex = '999';

    menu.children
      ..add(new Element.html('<li>New</li>'))
      ..add(new Element.html('<li>Open</li>'))
      ..add(new Element.html('<li>Save</li>'))
      ..add(new Element.html('<li>Make a Copy</li>'))
      ..add(_shareMenuItem())
      ..add(new Element.html('<li>Download</li>'))
      ..add(new Element.html('<li>Help</li>'));
  }

  _hideMenu() {
    query('.ice-menu').remove();
  }

  _shareMenuItem() {
    return new Element.html('<li>Share</li>')
      ..onClick.listen((e) => _openShareDialog());
  }

  _openShareDialog() {
    var dialog = new Element.html(
        '''
        <div class=ice-dialog>
        <h1>Copy this link to share your creation:</h1>
        <input
          value="http://gamingjs.com/ice/#B/${encodedContent}"
          style="width=400px; padding=5px; border=0px">
        </div>
        '''
    );

    el.children.add(dialog);

    dialog.style
      ..left = "${(window.innerWidth - dialog.offsetWidth)/2}px"
      ..top = "${(window.innerHeight - dialog.offsetHeight)/2}px";
  }

  String get encodedContent => Gzip.encode(_ice.content);

  _fullScreenStyles() {
    document.body.style
      ..margin = '0px'
      ..overflow = 'hidden';
  }

  _applyStyles() {
     var editor_el = el.query('.ice-code-editor-editor');

     editor_el.style
       ..top = '0'
       ..bottom = '0'
       ..left = '0'
       ..right = '0'
       ..backgroundColor = 'rgba(255,255,255,0.0)';

     el.style
       ..height = '100%'
       ..width = '100%';
  }
}