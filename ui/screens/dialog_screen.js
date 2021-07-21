/*
 *  @Project:		Battle Brothers
 *	@Company:		Overhype Studios
 *
 *	@Copyright:		(c) Overhype Studios | 2016 
 * 
 *  @Author:		Overhype Studios
 *  @Date:			26.02.2015
 *  @Description:	Dialog Screen JS
 */
"use strict";


var DialogScreen = function()
{
	this.mSQHandle = null;

	// generic containers
	this.mContainer = null;
    this.mDialogContainer = null;

    // buttons
    this.mButtonBar = null;
    this.mOkButton = null;
	this.mCancelButton = null;
    this.mText = null;
};


DialogScreen.prototype.isConnected = function ()
{
    return this.mSQHandle !== null;
};

DialogScreen.prototype.onConnection = function (_handle)
{
	//if (typeof(_handle) == 'string')
	{
		this.mSQHandle = _handle;
		this.register($('.root-screen'));
	}
};

DialogScreen.prototype.onDisconnection = function ()
{
	this.mSQHandle = null;
	this.unregister();
};


DialogScreen.prototype.createDIV = function (_parentDiv)
{
    var self = this;

	// create: containers (init hidden!)
	this.mContainer = $('<div class="dialog-screen ui-control dialog-modal-background display-none opacity-none"/>');
    _parentDiv.append(this.mContainer);

    // create: dialog container
    var dialogLayout = $('<div class="l-dialog-container"/>');
    this.mContainer.append(dialogLayout);
    this.mDialogContainer = dialogLayout.createDialog('Etes-vous sûr?', null, null, false);

    // create content
    this.mContentContainer = this.mDialogContainer.findDialogContentContainer();
    
    // create footer button bar
    var footerButtonBar = $('<div class="l-button-bar"></div>');
    this.mDialogContainer.findDialogFooterContainer().append(footerButtonBar);
    this.mButtonBar = footerButtonBar;

    // create: buttons
    var layout = $('<div class="l-ok-button"/>');
    footerButtonBar.append(layout);
    this.mOkButton = layout.createTextButton("Oui", function ()
    {
        self.notifyBackendOkButtonPressed();
    }, '', 1);
    
    var layout = $('<div class="l-cancel-button"/>');
    footerButtonBar.append(layout);
    this.mCancelButton = layout.createTextButton("Non", function ()
    {
        self.notifyBackendCancelButtonPressed();
    }, '', 1);
};

DialogScreen.prototype.destroyDIV = function ()
{
    this.mOkButton.remove();
    this.mOkButton = null;
    this.mCancelButton.remove();
    this.mCancelButton = null;
    
    this.mContentContainer.remove();
    this.mContentContainer = null;

    this.mDialogContainer.empty();
    this.mDialogContainer.remove();
    this.mDialogContainer = null;

    this.mContainer.empty();
    this.mContainer.remove();
    this.mContainer = null;
};


DialogScreen.prototype.bindTooltips = function ()
{
    //this.mFleeButton.bindTooltip({ contentType: 'ui-element', elementId: TooltipIdentifier.TacticalCombatResultScreen.LeaveButton });
};

DialogScreen.prototype.unbindTooltips = function ()
{
    //this.mFleeButton.unbindTooltip();
};

DialogScreen.prototype.create = function(_parentDiv)
{
    this.createDIV(_parentDiv);
    this.bindTooltips();
};

DialogScreen.prototype.destroy = function()
{
    this.unbindTooltips();
    this.destroyDIV();
};


DialogScreen.prototype.register = function (_parentDiv)
{
    console.log('DialogScreen::REGISTER');

    if (this.mContainer !== null)
    {
        console.error('ERROR: Failed to register Dialog Screen. Reason: Already initialized.');
        return;
    }

    if (_parentDiv !== null && typeof(_parentDiv) == 'object')
    {
        this.create(_parentDiv);
    }
};

DialogScreen.prototype.unregister = function ()
{
    console.log('DialogScreen::UNREGISTER');

    if (this.mContainer === null)
    {
        console.error('ERROR: Failed to unregister Dialog Screen. Reason: Not initialized.');
        return;
    }

    this.destroy();
};


DialogScreen.prototype.show = function (_data)
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

DialogScreen.prototype.hide = function ()
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


DialogScreen.prototype.getModule = function (_name)
{
	switch(_name)
	{
        default: return null;
	}
};

DialogScreen.prototype.getModules = function ()
{
	return [
    ];
};

DialogScreen.prototype.loadFromData = function (_data)
{
    this.mContentContainer.empty();

    var leftColumn = $('<div class="left-column"/>');
    this.mContentContainer.append(leftColumn);
    var imageLayer = $('<div class="l-ok-image"/>');
    leftColumn.append(imageLayer);

    var rightColumn = $('<div class="right-column "/>');
    this.mContentContainer.append(rightColumn);
    
	this.mDialogContainer.findDialogTitle().html(_data.Title);

    var textLabel = $('<div class="dialog-text text-font-medium font-color-description font-style-normal">' + _data.Text + '</div>');
    rightColumn.append(textLabel);

    if (_data.IsMonologue)
    {
        this.mOkButton.changeButtonText("Ok");
        this.mOkButton.addClass("is-centered");
        this.mCancelButton.addClass("display-none");
    }
    else
    {
        this.mOkButton.changeButtonText("Oui");
        this.mOkButton.removeClass("is-centered");
        this.mCancelButton.removeClass("display-none");
    }
}

DialogScreen.prototype.notifyBackendOnConnected = function ()
{
	if (this.mSQHandle !== null)
	{
		SQ.call(this.mSQHandle, 'onScreenConnected');
	}
};

DialogScreen.prototype.notifyBackendOnDisconnected = function ()
{
	if (this.mSQHandle !== null)
	{
		SQ.call(this.mSQHandle, 'onScreenDisconnected');
	}
};

DialogScreen.prototype.notifyBackendOnShown = function ()
{
    if (this.mSQHandle !== null)
    {
        SQ.call(this.mSQHandle, 'onScreenShown');
    }
};

DialogScreen.prototype.notifyBackendOnHidden = function ()
{
    if (this.mSQHandle !== null)
    {
        SQ.call(this.mSQHandle, 'onScreenHidden');
    }
};

DialogScreen.prototype.notifyBackendOnAnimating = function ()
{
    if (this.mSQHandle !== null)
    {
        SQ.call(this.mSQHandle, 'onScreenAnimating');
    }
};

DialogScreen.prototype.notifyBackendOkButtonPressed = function ()
{
    if (this.mSQHandle !== null)
    {
        SQ.call(this.mSQHandle, 'onOkPressed');
    }
};

DialogScreen.prototype.notifyBackendCancelButtonPressed = function ()
{
    if (this.mSQHandle !== null)
    {
        SQ.call(this.mSQHandle, 'onCancelPressed');
    }
};