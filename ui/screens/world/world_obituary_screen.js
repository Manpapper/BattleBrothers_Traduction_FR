/*
 *  @Project:		Battle Brothers
 *	@Company:		Overhype Studios
 *
 *	@Copyright:		(c) Overhype Studios | 2015
 * 
 *  @Author:		Overhype Studios
 *  @Date:			31.10.2017
 *  @Description:	World Relations Screen JS
 */
"use strict";

var WorldObituaryScreen = function(_parent)
{
	this.mSQHandle = null;

	// generic containers
	this.mContainer = null;
    this.mDialogContainer = null;
    this.mListContainer = null;
    this.mListScrollContainer = null;

    // buttons
    this.mLeaveButton = null;

    // generics
    this.mIsVisible = false;

    // selected entry
    this.mSelectedEntry = null;
};

WorldObituaryScreen.prototype.isConnected = function ()
{
    return this.mSQHandle !== null;
};

WorldObituaryScreen.prototype.onConnection = function (_handle)
{
	this.mSQHandle = _handle;
	this.register($('.root-screen'));
};

WorldObituaryScreen.prototype.onDisconnection = function ()
{
	this.mSQHandle = null;
	this.unregister();
};

WorldObituaryScreen.prototype.getModule = function (_name)
{
	switch(_name)
	{
        default: return null;
	}
};

WorldObituaryScreen.prototype.getModules = function ()
{
	return [];
};

WorldObituaryScreen.prototype.createDIV = function (_parentDiv)
{
    var self = this;

	// create: containers (init hidden!)
     this.mContainer = $('<div class="world-obituary-screen display-none opacity-none"/>');
     _parentDiv.append(this.mContainer);

    // create: containers (init hidden!)
    var dialogLayout = $('<div class="l-obituary-dialog-container"/>');
    this.mContainer.append(dialogLayout);
    this.mDialogContainer = dialogLayout.createDialog('Carnet de deuil', '', '', true, 'dialog-1024-768');

    // create tabs
    var tabButtonsContainer = $('<div class="l-tab-container"/>');
    this.mDialogContainer.findDialogTabContainer().append(tabButtonsContainer);

    // create content
    var content = this.mDialogContainer.findDialogContentContainer();

	// column headers
    var headers = $('<div class="table-header"/>');
    content.append(headers);

    this.mColumnName = $('<div class="table-header-name title title-font-big font-bold font-color-title">Nom</div>');
    headers.append(this.mColumnName);

    this.mColumnTime = $('<div class="table-header-time title title-font-big font-bold font-color-title">Jours</div>');
    headers.append(this.mColumnTime);

    this.mColumnBattles = $('<div class="table-header-battles title title-font-big font-bold font-color-title">Batailles</div>');
    headers.append(this.mColumnBattles);

    this.mColumnKills = $('<div class="table-header-kills title title-font-big font-bold font-color-title">Tués</div>');
    headers.append(this.mColumnKills);

    this.mColumnKilledBy = $('<div class="table-header-killed-by title title-font-big font-bold font-color-title">Mort</div>');
    headers.append(this.mColumnKilledBy);

    // left column
    var column = $('<div class="column is-left"/>');
    content.append(column);
    var listContainerLayout = $('<div class="l-list-container"/>');
    column.append(listContainerLayout);
    this.mListContainer = listContainerLayout.createList(1.0/*8.85*/);
    this.mListScrollContainer = this.mListContainer.findListScrollContainer();

    // create footer button bar
    var footerButtonBar = $('<div class="l-button-bar"/>');
    this.mDialogContainer.findDialogFooterContainer().append(footerButtonBar);

    // create: buttons
    var layout = $('<div class="l-leave-button"/>');
    footerButtonBar.append(layout);
    this.mLeaveButton = layout.createTextButton("Fermer", function()
	{
        self.notifyBackendCloseButtonPressed();
    }, '', 1);

    this.mIsVisible = false;
};

WorldObituaryScreen.prototype.destroyDIV = function ()
{
	//this.mAssets.destroyDIV();

    this.mListScrollContainer.empty();
    this.mListScrollContainer = null;
    this.mListContainer.destroyList();
    this.mListContainer.remove();
    this.mListContainer = null;

	this.mLeaveButton.remove();
    this.mLeaveButton = null;

    this.mDialogContainer.empty();
    this.mDialogContainer.remove();
    this.mDialogContainer = null;

    this.mContainer.empty();
    this.mContainer.remove();
    this.mContainer = null;
};


WorldObituaryScreen.prototype.addListEntry = function (_data)
{
	var result = $('<div class="l-row"/>');
	this.mListScrollContainer.append(result);

	var name = $('<div class="name text-font-normal font-color-description">' + _data.Name + '</div>');
	result.append(name);

	var time = $('<div class="time text-font-normal font-color-description">' + _data.TimeWithCompany + '</div>');
	result.append(time);

	var battles = $('<div class="battles text-font-normal font-color-description">' + _data.Battles + '</div>');
	result.append(battles);

	var kills = $('<div class="kills text-font-normal font-color-description">' + _data.Kills + '</div>');
	result.append(kills);

	var killedBy = $('<div class="killed-by text-font-normal font-color-description">' + _data.KilledBy + '</div>');
	result.append(killedBy);
};

WorldObituaryScreen.prototype.bindTooltips = function ()
{
	this.mColumnName.bindTooltip({ contentType: 'ui-element', elementId: TooltipIdentifier.WorldScreen.Obituary.ColumnName });
	this.mColumnTime.bindTooltip({ contentType: 'ui-element', elementId: TooltipIdentifier.WorldScreen.Obituary.ColumnTime });
	this.mColumnBattles.bindTooltip({ contentType: 'ui-element', elementId: TooltipIdentifier.WorldScreen.Obituary.ColumnBattles });
	this.mColumnKills.bindTooltip({ contentType: 'ui-element', elementId: TooltipIdentifier.WorldScreen.Obituary.ColumnKills });
	this.mColumnKilledBy.bindTooltip({ contentType: 'ui-element', elementId: TooltipIdentifier.WorldScreen.Obituary.ColumnKilledBy });
};

WorldObituaryScreen.prototype.unbindTooltips = function ()
{
	this.mColumnName.unbindTooltip();
	this.mColumnTime.unbindTooltip();
	this.mColumnBattles.unbindTooltip();
	this.mColumnKills.unbindTooltip();
	this.mColumnKilledBy.unbindTooltip();
};


WorldObituaryScreen.prototype.create = function(_parentDiv)
{
    this.createDIV(_parentDiv);
    this.bindTooltips();
};

WorldObituaryScreen.prototype.destroy = function()
{
    this.unbindTooltips();
    this.destroyDIV();
};


WorldObituaryScreen.prototype.register = function (_parentDiv)
{
    console.log('WorldObituaryScreen::REGISTER');

    if (this.mContainer !== null)
    {
        console.error('ERROR: Failed to register Relations Screen. Reason: Already initialized.');
        return;
    }

    if (_parentDiv !== null && typeof(_parentDiv) == 'object')
    {
        this.create(_parentDiv);
    }
};

WorldObituaryScreen.prototype.unregister = function ()
{
    console.log('WorldObituaryScreen::UNREGISTER');

    if (this.mContainer === null)
    {
        console.error('ERROR: Failed to unregister Relations Screen. Reason: Not initialized.');
        return;
    }

    this.destroy();
};

WorldObituaryScreen.prototype.isRegistered = function ()
{
    if (this.mContainer !== null)
    {
        return this.mContainer.parent().length !== 0;
    }

    return false;
};


WorldObituaryScreen.prototype.show = function (_data)
{
    this.loadFromData(_data);

	if(!this.mIsVisible)
	{
		var self = this;

		var withAnimation = true;//(_data !== undefined && _data['withSlideAnimation'] !== null) ? _data['withSlideAnimation'] : true;
		if (withAnimation === true)
		{
			var offset = -(this.mContainer.parent().width() + this.mContainer.width());
			this.mContainer.css({ 'left': offset });
			this.mContainer.velocity("finish", true).velocity({ opacity: 1, left: '0', right: '0' }, {
				duration: Constants.SCREEN_SLIDE_IN_OUT_DELAY,
				easing: 'swing',
				begin: function () {
					$(this).removeClass('display-none').addClass('display-block');
					self.notifyBackendOnAnimating();
				},
				complete: function () {
					self.mIsVisible = true;
					self.notifyBackendOnShown();
				}
			});
		}
		else
		{
			this.mContainer.css({ opacity: 0 });
			this.mContainer.velocity("finish", true).velocity({ opacity: 1 }, {
				duration: Constants.SCREEN_FADE_IN_OUT_DELAY,
				easing: 'swing',
				begin: function() {
					$(this).removeClass('display-none').addClass('display-block');
					self.notifyBackendOnAnimating();
				},
				complete: function() {
					self.mIsVisible = true;
					self.notifyBackendOnShown();
				}
			});
		}
	}
};

WorldObituaryScreen.prototype.hide = function (_withSlideAnimation)
{
    var self = this;

    var withAnimation = true;//(_withSlideAnimation !== undefined && _withSlideAnimation !== null) ? _withSlideAnimation : true;
    if (withAnimation === true)
    {
        var offset = -(this.mContainer.parent().width() + this.mContainer.width());
        this.mContainer.velocity("finish", true).velocity({ opacity: 0, left: offset },
		{
            duration: Constants.SCREEN_SLIDE_IN_OUT_DELAY,
            easing: 'swing',
            begin: function ()
            {
                $(this).removeClass('is-center');
                self.notifyBackendOnAnimating();
            },
            complete: function ()
            {
            	self.mIsVisible = false;
            	self.mListScrollContainer.empty();
                $(this).removeClass('display-block').addClass('display-none');
                self.notifyBackendOnHidden();
            }
        });
    }
    else
    {
    	this.mContainer.velocity("finish", true).velocity({ opacity: 0 },
		{
            duration: Constants.SCREEN_SLIDE_IN_OUT_DELAY,
            easing: 'swing',
            begin: function ()
            {
                $(this).removeClass('is-center');
                self.notifyBackendOnAnimating();
            },
            complete: function ()
            {
                self.mIsVisible = false;
                self.mListScrollContainer.empty();
                $(this).removeClass('display-block').addClass('display-none');
                self.notifyBackendOnHidden();
            }
        });
    }
};

WorldObituaryScreen.prototype.isVisible = function ()
{
    return this.mIsVisible;
};


WorldObituaryScreen.prototype.loadFromData = function (_data)
{
    if(_data === undefined || _data === null)
    {
        return;
    }

    this.mListScrollContainer.empty();

    if(_data.Fallen.length == 0)
    	this.mDialogContainer.findDialogSubTitle().text('No one has fallen since you took command');
    else if(_data.Fallen.length == 1)
		this.mDialogContainer.findDialogSubTitle().text('A single man has fallen since you took command');
    else
    	this.mDialogContainer.findDialogSubTitle().text('' + _data.Fallen.length + ' men have fallen since you took command');

	for(var i = 0; i < _data.Fallen.length; ++i)
    {
		this.addListEntry(_data.Fallen[i]);
    }
};

WorldObituaryScreen.prototype.notifyBackendOnConnected = function ()
{
	if(this.mSQHandle !== null)
	{
		SQ.call(this.mSQHandle, 'onScreenConnected');
	}
};

WorldObituaryScreen.prototype.notifyBackendOnDisconnected = function ()
{
	if(this.mSQHandle !== null)
	{
		SQ.call(this.mSQHandle, 'onScreenDisconnected');
	}
};

WorldObituaryScreen.prototype.notifyBackendOnShown = function ()
{
    if(this.mSQHandle !== null)
    {
        SQ.call(this.mSQHandle, 'onScreenShown');
    }
};

WorldObituaryScreen.prototype.notifyBackendOnHidden = function ()
{
    if(this.mSQHandle !== null)
    {
        SQ.call(this.mSQHandle, 'onScreenHidden');
    }
};

WorldObituaryScreen.prototype.notifyBackendOnAnimating = function ()
{
    if(this.mSQHandle !== null)
    {
        SQ.call(this.mSQHandle, 'onScreenAnimating');
    }
};

WorldObituaryScreen.prototype.notifyBackendCloseButtonPressed = function (_buttonID)
{
    if(this.mSQHandle !== null)
    {
        SQ.call(this.mSQHandle, 'onClose', _buttonID);
    }
};