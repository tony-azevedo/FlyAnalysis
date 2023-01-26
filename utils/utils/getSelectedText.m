function currentSelection = getSelectedText()

%# find the text area in the command window
jDesktop = com.mathworks.mde.desk.MLDesktop.getInstance;
try
  cmdWin = jDesktop.getClient('Editor');
  jTextArea = cmdWin.getComponent(0).getViewport.getComponent(0);
catch
  commandwindow;
  jTextArea = jDesktop.getMainFrame.getFocusOwner;
end

%# read the current selection
jTxt = jTextArea.getSelectedText;

if isempty(jTxt)
    currentSelection = [];
    return
end
%# turn into Matlab text
currentSelection = jTxt.toCharArray'; %'

%# display
disp(currentSelection)

