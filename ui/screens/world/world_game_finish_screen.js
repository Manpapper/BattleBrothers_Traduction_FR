/*
 *  @Project:		Battle Brothers
 *	@Company:		Overhype Studios
 *
 *	@Copyright:		(c) Overhype Studios | 2013 - 2020
 * 
 *  @Author:		Overhype Studios
 *  @Date:			23.11.2017
 *  @Description:	World Game Finish Screen JS
 */
"use strict";


var WorldGameFinishScreen = function()
{
	this.mSQHandle = null;

	// generic containers
	this.mContainer = null;
	this.mListContainer = null;
	this.mListScrollContainer = null;

	// content
	this.mBackground = null;
	this.mScore = null;
	this.mQuitButton = null;

    this.mIsVisible = false;
};


WorldGameFinishScreen.prototype.isConnected = function ()
{
    return this.mSQHandle !== null;
};

WorldGameFinishScreen.prototype.onConnection = function (_handle)
{
	this.mSQHandle = _handle;
    this.register($('.root-screen'));
};

WorldGameFinishScreen.prototype.onDisconnection = function ()
{
	this.mSQHandle = null;
	this.unregister();
};

WorldGameFinishScreen.prototype.getModule = function (_name)
{
	switch (_name)
	{
		default: return null;
	}
};

WorldGameFinishScreen.prototype.getModules = function ()
{
	return [
	];
};


WorldGameFinishScreen.prototype.createDIV = function (_parentDiv)
{
	var self = this;

	// create: containers (init hidden!)
	this.mContainer = $('<div class="world-game-finish-screen ui-control dialog-modal-background-black display-none opacity-none"/>');
	_parentDiv.append(this.mContainer);

	// background image
	this.mBackground = this.mContainer.createImage(null, function (_image)
	{
		_image.removeClass('display-none').addClass('display-block');
		_image.fitImageToParent();
	}, function (_image)
	{
		_image.fitImageToParent();
	}, 'background-image display-none');

	// create: content
	var content = $('<div class="content-container"/>');
	this.mContainer.append(content);

	var listContainerLayout = $('<div class="l-list-container"/>');
	content.append(listContainerLayout);
	this.mListContainer = listContainerLayout.createList(10, null, true);
	this.mListScrollContainer = this.mListContainer.findListScrollContainer();

	// create: score bar
	this.mScore = $('<div class="score-container title-font-big font-bold font-color-title"/>');
	this.mContainer.append(this.mScore);

	// create: footer button bar
	var buttons = $('<div class="button-container"/>');
	this.mContainer.append(buttons);

	// button
	var layout = $('<div class="l-quit-button"/>');
	buttons.append(layout);
	this.mQuitButton = layout.createTextButton("Quitter", function ()
	{
		self.notifyBackendQuitButtonPressed();
	}, '', 1);

	this.mIsVisible = false;
};

WorldGameFinishScreen.prototype.destroyDIV = function ()
{
    this.mContainer.empty();
    this.mContainer.remove();
    this.mContainer = null;
};


WorldGameFinishScreen.prototype.create = function(_parentDiv)
{
    this.createDIV(_parentDiv);
};

WorldGameFinishScreen.prototype.destroy = function()
{
    this.destroyDIV();
};


WorldGameFinishScreen.prototype.register = function (_parentDiv)
{
    console.log('WorldGameFinishScreen::REGISTER');

    if (this.mContainer !== null)
    {
        console.error('ERROR: Failed to register World Game Finish Screen. Reason: Screen is already initialized.');
        return;
    }

    if (_parentDiv !== null && typeof(_parentDiv) == 'object')
    {
        this.create(_parentDiv);
    }
};

WorldGameFinishScreen.prototype.unregister = function ()
{
    console.log('WorldGameFinishScreen::UNREGISTER');

    if (this.mContainer === null)
    {
        console.error('ERROR: Failed to unregister World Game Finish Screen. Reason: Screen is not initialized.');
        return;
    }

    this.destroy();
};


WorldGameFinishScreen.prototype.show = function (_data)
{
    this.loadFromData(_data);

    var self = this;
    this.mContainer.velocity("finish", true).velocity({ opacity: 1 },
    {
        duration: Constants.SCREEN_FADE_IN_OUT_DELAY,
        easing: 'swing',
        begin: function ()
        {
            $(this).removeClass('display-none').addClass('display-block');
            self.notifyBackendOnAnimating();
        },
        complete: function ()
        {
            self.mIsVisible = true;
            self.notifyBackendOnShown();
        }
    });
};

WorldGameFinishScreen.prototype.hide = function ()
{
    var self = this;

    this.mContainer.velocity("finish", true).velocity({ opacity: 0 },
    {
        duration: Constants.SCREEN_FADE_IN_OUT_DELAY,
        easing: 'swing',
        begin: function ()
        {
            self.notifyBackendOnAnimating();
        },
        complete: function ()
        {
            self.mIsVisible = false;
            $(this).removeClass('display-block').addClass('display-none');
            self.notifyBackendOnHidden();
        }
    });
};


WorldGameFinishScreen.prototype.loadFromData = function (_data)
{
	this.mBackground.attr('src', Path.GFX + _data.Image);

	var row = $('<div class="row"/>');
	this.mListScrollContainer.append(row);

	var description = $('<div class="description text-font-medium font-bottom-shadow font-color-description"/>');
	row.append(description);

	var parsedDescriptionText = XBBCODE.process({
		text: _data.Text,
		removeMisalignedTags: false,
		addInLineBreaks: true
	});

	description.html(parsedDescriptionText.html);

	this.mScore.text(_data.Score);
}


WorldGameFinishScreen.prototype.notifyBackendOnConnected = function ()
{
	if (this.mSQHandle !== null)
	{
		SQ.call(this.mSQHandle, 'onScreenConnected');
	}
};

WorldGameFinishScreen.prototype.notifyBackendOnDisconnected = function ()
{
	if (this.mSQHandle !== null)
	{
		SQ.call(this.mSQHandle, 'onScreenDisconnected');
	}
};

WorldGameFinishScreen.prototype.notifyBackendOnShown = function ()
{
    if (this.mSQHandle !== null)
    {
        SQ.call(this.mSQHandle, 'onScreenShown');
    }
};

WorldGameFinishScreen.prototype.notifyBackendOnHidden = function ()
{
    if (this.mSQHandle !== null)
    {
        SQ.call(this.mSQHandle, 'onScreenHidden');
    }
};

WorldGameFinishScreen.prototype.notifyBackendOnAnimating = function ()
{
    if (this.mSQHandle !== null)
    {
        SQ.call(this.mSQHandle, 'onScreenAnimating');
    }
};

WorldGameFinishScreen.prototype.notifyBackendQuitButtonPressed = function ()
{
	if(this.mSQHandle !== null)
	{
		SQ.call(this.mSQHandle, 'onQuitButtonPressed');
	}
};