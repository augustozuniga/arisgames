var rowID = 0;
var message;
var currentChar = 0;
var intervalObject;
var messageContainer;
var messageQueue = Array();
var messageNumber = -1;
var npcID;
var initialOptions = '';

var userInput = '';

function getMessageQueue(queueId) {
	if (userInput != '') {
		userInput = '&answer_string=' + URLEncode(userInput);
	}

	// Note the queueId is analagous to the nodeId
	var request = new XMLHttpRequest();
	request.open('GET', wwwBase + '/index.php?site=' + site + '&module=IMNode&controller=JSON&nodeID='
		+ queueId + '&npcID=' + npcID + userInput, true);
	request.setRequestHeader('Content-Type', 'application/x-javascript;');        	
	request.onreadystatechange = function() {
		if (request.readyState == 4 && request.status == 200) {
			// Extract the JSON object
			var data = eval('(' + request.responseText + ')');
			callback_getMessageQueue(data);
		}
	}
    request.send('');
    userInput = '';
}

function callback_getMessageQueue(queue) {
    messageQueue = queue;
    messageNumber = -1;
    processCurrentMessage();
}

function processCurrentMessage() {
    messageNumber++;
    
    if (messageNumber < messageQueue['phrases'].length) {
        message = messageQueue['phrases'][messageNumber];
        if (message['isNPC']) setNPCMessage();
        else setTimeout(printPlayerMessage, message['delay']);
    } else if (messageQueue['requiresInput']) {
    	prepUserInput();
    } else if (messageQueue['options'].length > 0) {
        setTimeout(makeOptions, messageQueue['optionDelay']);
    }
}

function prepOptions(id, text) {
	select = document.getElementById('playerMessageSelection');
	select.innerHTML = select.innerHTML
		+ '<option value="' + id + '">' + text + "</option>\n";

	initialOptions = initialOptions 
		+ '<a href="#" onclick="parent.selectOption(' + "'" + id 
		+ "'" + ')">' + text + '</a><br/>';
		
	var opt = new Array();
	opt['queueId'] = id;
	opt['phrase'] = text;
	messageQueue['options'].push(opt);
}

function postSelection() {
	select = document.getElementById('playerMessageSelection');
	if (select.selectedIndex == 0) return;
	
	selectOption(select.options[select.selectedIndex].value);
}

function startOptions() {
	document.getElementById('message').style.visibility = 'hidden';
	document.getElementById('playerMessageSendButton').style.visibility = 'hidden';
	document.getElementById('playerMessageSelection').style.visibility = 'visible';

	makeRow('right', '...', messageQueue['player_icon']);
}

function makeOptions() {
	document.getElementById('message').style.visibility = 'hidden';
	document.getElementById('playerMessageSendButton').style.visibility = 'hidden';

    var msg = '<option value="">Say...</option>';
    for (var i = 0; i < messageQueue['options'].length; i++) {
        option = messageQueue['options'][i];
        msg = msg + '<option value="' + option['queueId'] + '">'
        	+ option['phrase'] + '</option>';
    }
    document.getElementById('playerMessageSelection').innerHTML = msg;
    makeRow('right', '...', messageQueue['player_icon']);
	document.getElementById('playerMessageSelection').style.visibility = 'visible';
}    

function selectOption(queueId) {
    for (var i = 0; i < messageQueue['options'].length; i++) {
        if (queueId == messageQueue['options'][i]['queueId']) {
            setRowMessage('right', messageQueue['options'][i]['phrase'], messageQueue['player_icon']);
            break;
        }
    }
    document.getElementById('message').style.visibility = 'visible';
	document.getElementById('playerMessageSendButton').style.visibility = 'visible';
	document.getElementById('playerMessageSelection').style.visibility = 'hidden';
    getMessageQueue(queueId);
}

function prepUserInput() {
	messageContainer = document.getElementById('message');
	messageContainer.disabled = false;
	messageContainer.value = "Enter answer";
	messageContainer.focus();
	messageContainer.select();
	
	var msgButton = document.getElementById('playerMessageSendButton');
	msgButton.onclick = processUserInput;
	msgButton.disabled = false;
}

function processUserInput() {
	var msgButton = document.getElementById('playerMessageSendButton');
	msgButton.disabled = true;
	msgButton.onclick = playerMessageSendButton;
	
	messageContainer = document.getElementById('message');
	messageContainer.disabled = true;
	message['phrase'] = messageContainer.value;
	
	userInput = messageContainer.value;
	postPlayerMessage();
	getMessageQueue(messageQueue['id']);
}

function setNPCMessage() {
    makeRow('left', '...', messageQueue['npc_icon']);
	setTimeout(writeNPCMessage, message['delay']);
}

function writeNPCMessage() {
    setRowMessage('left', message['phrase'], messageQueue['npc_icon']);
    processCurrentMessage();
}

function printPlayerMessage() {
	messageContainer = document.getElementById("message");
	messageContainer.value = " ";
	
	intervalObject = setInterval(typeMessage, 75);
	currentChar = 0;
	document.getElementById("rawMessage").innerHTML = message['phrase'];
	message['phrase'] = message['phrase'].replace(/(<([^>]+)>)/ig, "");
}

function typeMessage() {
    if (currentChar < message['phrase'].length) {
		messageContainer.value = 
			message['phrase'].substring(0, ++currentChar);
	} else {
	    clearInterval(intervalObject);
        var button = document.getElementById("playerMessageSendButton");
        button.disabled = false;
	}
}

function postPlayerMessage() {
    var button = document.getElementById("playerMessageSendButton");
    button.disabled = true;
    makeRow('right', message['phrase'], messageQueue['player_icon']);
    messageContainer.value = " ";
    processCurrentMessage();
}

function makeRow(alignment, msg, icon_url) {
    rowID++;
    var container = frames[0].document.getElementById("dialog");
	container.innerHTML = container.innerHTML +  '<tr><td align="' + alignment + '" id="r' + rowID + '">' + createIcon(alignment, icon_url) + msg + '</td></tr>';
    frames[0].scrollToBottom();
}

function setRowMessage(alignment, msg, icon_url) {
	var row = frames[0].document.getElementById("r" + rowID);
	row.innerHTML = createIcon(alignment, icon_url) + msg;
    frames[0].scrollToBottom();
}    

function createIcon(alignment, icon_url) {
    if (alignment == 'left') {
        padding = "right";
    } else {
        padding = "left";
    }
    return '<img alt="icon" width="48" src="' + icon_url +'" style="float:' + alignment +';padding-' + padding + ':5px;"/>';
}

function URLEncode(clearString) {
	var output = '';
	var x = 0;
	clearString = clearString.toString();
	var regex = /(^[a-zA-Z0-9_.]*)/;
	while (x < clearString.length) {
		var match = regex.exec(clearString.substr(x));
		if (match != null && match.length > 1 && match[1] != '') {
			output += match[1];
			x += match[1].length;
		} else {
			if (clearString[x] == ' ')
				output += '+';
			else {
				var charCode = clearString.charCodeAt(x);
				var hexVal = charCode.toString(16);
				output += '%' + ( hexVal.length < 2 ? '0' : '' ) 
					+ hexVal.toUpperCase();
			}
			x++;
		}
	}
	return output;
}