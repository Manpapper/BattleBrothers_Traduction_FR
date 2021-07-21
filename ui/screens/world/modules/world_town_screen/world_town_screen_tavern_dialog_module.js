
"use strict";

var WorldTownScreenTavernDialogModule = function(_parent)
{
	this.mSQHandle = null;
    this.mParent = _parent;

	this.mRoster = null;

    // event listener
    this.mEventListener = null;

	// generic containers
	this.mContainer = null;
    this.mDialogContainer = null;

	this.mLeftDetailsPanel = {
        Container: null,
        Info: null,
		Image: null,
        Name: null,
        Result: null,
        Button: null
    };

    this.mRightDetailsPanel = {
        Container: null,
        Info: null,
		Image: null,
        Name: null,
        Result: null,
        Button: null
    };

    // assets labels
	this.mAssets = new WorldTownScreenAssets(_parent);

    // buttons
    this.mLeaveButton = null;

    // generics
    this.mIsVisible = false;
};


WorldTownScreenTavernDialogModule.prototype.isConnected = function ()
{
    return this.mSQHandle !== null;
};

WorldTownScreenTavernDialogModule.prototype.onConnection = function (_handle)
{
	this.mSQHandle = _handle;

    // notify listener
    if (this.mEventListener !== null && ('onModuleOnConnectionCalled' in this.mEventListener))
	{
        this.mEventListener.onModuleOnConnectionCalled(this);
    }
};

WorldTownScreenTavernDialogModule.prototype.onDisconnection = function ()
{
	this.mSQHandle = null;

    // notify listener
    if (this.mEventListener !== null && ('onModuleOnDisconnectionCalled' in this.mEventListener))
	{
        this.mEventListener.onModuleOnDisconnectionCalled(this);
    }
};

WorldTownScreenTavernDialogModule.prototype.createDIV = function (_parentDiv)
{
    var self = this;

    // create: containers (init hidden!)
    this.mContainer = $('<div class="l-tavern-dialog-container display-none opacity-none"/>');
    _parentDiv.append(this.mContainer);
    this.mDialogContainer = this.mContainer.createDialog('Taverne', '', '', true, 'dialog-1024-768');

    // create tabs
    var tabButtonsContainer = $('<div class="l-tab-container"/>');
    this.mDialogContainer.findDialogTabContainer().append(tabButtonsContainer);

	// create assets
	this.mAssets.createDIV(tabButtonsContainer);

    // create content
    var content = this.mDialogContainer.findDialogContentContainer();

    // left column
    var column = $('<div class="column is-left"/>');
    content.append(column);

	// left details container
    var detailsFrame = $('<div class="l-details-frame"/>');
    column.append(detailsFrame);
    this.mLeftDetailsPanel.Container = $('<div class="details-container"/>');
    detailsFrame.append(this.mLeftDetailsPanel.Container);
	
	// details: character container
    var detailsRow = $('<div class="row is-character-container"/>');
    this.mLeftDetailsPanel.Container.append(detailsRow);
    var detailsColumn = $('<div class="column is-character-portrait-container"/>');
    detailsRow.append(detailsColumn);
    this.mLeftDetailsPanel.Image = detailsColumn.createImage(Path.GFX + Asset.IMAGE_TAVERN_RUMORS, null, null, '');
    detailsColumn = $('<div class="column is-character-background-container"/>');
    detailsRow.append(detailsColumn);

	var backgroundRow = $('<div class="row is-top"/>');
    detailsColumn.append(backgroundRow);
	var backgroundRowBorder = $('<div class="row is-top border"/>');
	backgroundRow.append(backgroundRowBorder);
	
	this.mLeftDetailsPanel.Name = $('<div class="name title-font-normal font-bold font-color-brother-name">Entendre les rumeurs et les dernières informations que les client ont</div>');
    backgroundRow.append(this.mLeftDetailsPanel.Name);
    backgroundRow = $('<div class="row is-bottom"/>');
    detailsColumn.append(backgroundRow);
	
	this.mLeftDetailsPanel.Info = $('<div class="column text-font-medium font-bottom-shadow font-color-description is-action-description"></div>');
    backgroundRow.append(this.mLeftDetailsPanel.Info);

	// pay button
	detailsRow = $('<div class="column is-button-container"/>');
    backgroundRow.append(detailsRow);
    var hireButtonLayout = $('<div class="l-tavern-button"/>');
    detailsRow.append(hireButtonLayout);
    this.mLeftDetailsPanel.Button = hireButtonLayout.createTextButton("Payer", function()
	{
        self.notifyBackendQueryRumor();
    }, '', 1);

	this.mLeftDetailsPanel.Result = $('<div class="column text-font-medium font-bottom-shadow font-color-description is-result"\>');
    backgroundRow.append(this.mLeftDetailsPanel.Result);

    // right column
    column = $('<div class="column is-right"/>');
    content.append(column);

    // right details container
    var detailsFrame = $('<div class="l-details-frame"/>');
    column.append(detailsFrame);
    this.mRightDetailsPanel.Container = $('<div class="details-container"/>');
    detailsFrame.append(this.mRightDetailsPanel.Container);
	
    // details: character container
    var detailsRow = $('<div class="row is-character-container"/>');
    this.mRightDetailsPanel.Container.append(detailsRow);
    var detailsColumn = $('<div class="column is-character-portrait-container"/>');
    detailsRow.append(detailsColumn);
    this.mLeftDetailsPanel.Image = detailsColumn.createImage(Path.GFX + Asset.IMAGE_TAVERN_DRINK, null, null, '');
    detailsColumn = $('<div class="column is-character-background-container"/>');
    detailsRow.append(detailsColumn);
	
    // details: background
    var backgroundRow = $('<div class="row is-top"/>');
    detailsColumn.append(backgroundRow);
	var backgroundRowBorder = $('<div class="row is-top border"/>');
	backgroundRow.append(backgroundRowBorder);
	
	this.mRightDetailsPanel.Name = $('<div class="name title-font-normal font-bold font-color-brother-name">Payer la tournée à vos hommes</div>');
    backgroundRow.append(this.mRightDetailsPanel.Name);
    backgroundRow = $('<div class="row is-bottom"/>');
    detailsColumn.append(backgroundRow);

	this.mRightDetailsPanel.Info = $('<div class="column text-font-medium font-bottom-shadow font-color-description is-action-description">Payer la tournée à vos hommes</div>');
    backgroundRow.append(this.mRightDetailsPanel.Info);

	// pay button
	detailsRow = $('<div class="column is-button-container"/>');
    backgroundRow.append(detailsRow);
    var hireButtonLayout = $('<div class="l-tavern-button"/>');
    detailsRow.append(hireButtonLayout);
    this.mRightDetailsPanel.Button = hireButtonLayout.createTextButton("Pay", function()
	{
        self.notifyBackendDrink();
    }, '', 1);

	this.mRightDetailsPanel.Result = $('<div class="column text-font-medium font-bottom-shadow font-color-description is-result"\>');
    backgroundRow.append(this.mRightDetailsPanel.Result);

    // create footer button bar
    var footerButtonBar = $('<div class="l-button-bar"/>');
    this.mDialogContainer.findDialogFooterContainer().append(footerButtonBar);

    // create: buttons
    var layout = $('<div class="l-leave-button"/>');
    footerButtonBar.append(layout);
    this.mLeaveButton = layout.createTextButton("Partir", function()
	{
        self.notifyBackendLeaveButtonPressed();
    }, '', 1);

    this.mIsVisible = false;
};

WorldTownScreenTavernDialogModule.prototype.destroyDIV = function ()
{
	this.mLeftDetailsPanel.Container.empty();
    this.mLeftDetailsPanel.Container.remove();
    this.mLeftDetailsPanel.Container = null;

    this.mRightDetailsPanel.Container.empty();
    this.mRightDetailsPanel.Container.remove();
    this.mRightDetailsPanel.Container = null;

	this.mLeaveButton.remove();
    this.mLeaveButton = null;

	this.mAssets.destroyDIV();
	//this.mAssets = null;

    this.mDialogContainer.empty();
    this.mDialogContainer.remove();
    this.mDialogContainer = null;

    this.mContainer.empty();
    this.mContainer.remove();
    this.mContainer = null;
};

WorldTownScreenTavernDialogModule.prototype.updateButtons = function (_data)
{
	if (_data.RumorPrice > this.mAssets.getValues().Money)
		this.mLeftDetailsPanel.Button.enableButton(false);
	else
		this.mLeftDetailsPanel.Button.enableButton(true);

	if (_data.DrinkPrice > this.mAssets.getValues().Money)
		this.mRightDetailsPanel.Button.enableButton(false);
	else
		this.mRightDetailsPanel.Button.enableButton(true);
}

WorldTownScreenTavernDialogModule.prototype.updateRumor = function(_data)
{
	if (_data === null)
		return;

	var parsedDescriptionText = XBBCODE.process({
        text: _data,
        removeMisalignedTags: false,
        addInLineBreaks: true
    });

    this.mLeftDetailsPanel.Result.html(parsedDescriptionText.html);
};


WorldTownScreenTavernDialogModule.prototype.updateDrinking = function(_data)
{
	if (_data === null)
		return;

	this.mRightDetailsPanel.Result.empty();

	var something = $('<div class="text-font-medium font-bottom-shadow font-color-description">' + _data.Intro + '</div><br>');
    this.mRightDetailsPanel.Result.append(something);

	var table = $('<table/>');

	for(var i=0; i != _data.Result.length; ++i)
	{
		var row = $('<tr/>');

		if('Icon' in _data.Result[i] && _data.Result[i].Icon !== null)
		{
			var image = $('<img class="list-image"/>');
			image.attr('src', Path.GFX + _data.Result[i].Icon);
			
			var cell = $('<td/>');
			cell.append(image);
			row.append(cell);
		}

		if('Text' in _data.Result[i] && _data.Result[i].Text !== null)
		{
			var text = $('<div class="text text-font-medium font-bottom-shadow font-color-description"/>');

			var parsedText = XBBCODE.process({
				text: _data.Result[i].Text,
				removeMisalignedTags: false,
				addInLineBreaks: true
			});

			text.html(parsedText.html);

			var cell = $('<td/>');
			cell.append(text);
			row.append(cell);
		}

		table.append(row);
	}

	this.mRightDetailsPanel.Result.append(table);
};


WorldTownScreenTavernDialogModule.prototype.bindTooltips = function ()
{
    this.mAssets.bindTooltips();
    this.mLeaveButton.bindTooltip({ contentType: 'ui-element', elementId: TooltipIdentifier.WorldTownScreen.HireDialogModule.LeaveButton });
};

WorldTownScreenTavernDialogModule.prototype.unbindTooltips = function ()
{
	this.mAssets.unbindTooltips();
    this.mLeaveButton.unbindTooltip();
};


WorldTownScreenTavernDialogModule.prototype.create = function(_parentDiv)
{
    this.createDIV(_parentDiv);
    this.bindTooltips();
};

WorldTownScreenTavernDialogModule.prototype.destroy = function()
{
    this.unbindTooltips();
    this.destroyDIV();
};


WorldTownScreenTavernDialogModule.prototype.register = function (_parentDiv)
{
    console.log('WorldTownScreenTavernDialogModule::REGISTER');

    if (this.mContainer !== null)
    {
        console.error('ERROR: Failed to register World Town Screen Hire Dialog Module. Reason: World Town Screen Hire Dialog Module is already initialized.');
        return;
    }

    if (_parentDiv !== null && typeof(_parentDiv) == 'object')
    {
        this.create(_parentDiv);
    }
};

WorldTownScreenTavernDialogModule.prototype.unregister = function ()
{
    console.log('WorldTownScreenTavernDialogModule::UNREGISTER');

    if (this.mContainer === null)
    {
        console.error('ERROR: Failed to unregister World Town Screen Hire Dialog Module. Reason: World Town Screen Hire Dialog Module is not initialized.');
        return;
    }

    this.destroy();
};

WorldTownScreenTavernDialogModule.prototype.isRegistered = function ()
{
    if (this.mContainer !== null)
    {
        return this.mContainer.parent().length !== 0;
    }

    return false;
};


WorldTownScreenTavernDialogModule.prototype.registerEventListener = function(_listener)
{
    this.mEventListener = _listener;
};


WorldTownScreenTavernDialogModule.prototype.show = function (_withSlideAnimation)
{
    var self = this;

    var withAnimation = (_withSlideAnimation !== undefined && _withSlideAnimation !== null) ? _withSlideAnimation : true;
    if (withAnimation === true)
    {
        var offset = -(this.mContainer.parent().width() + this.mContainer.width());
        this.mContainer.css({ 'left': offset });
        this.mContainer.velocity("finish", true).velocity({ opacity: 1, left: '0', right: '0' },
        {
            duration: Constants.SCREEN_SLIDE_IN_OUT_DELAY,
            easing: 'swing',
            begin: function ()
            {
                $(this).removeClass('display-none').addClass('display-block');
                self.notifyBackendModuleAnimating();
            },
            complete: function ()
            {
                self.mIsVisible = true;
                self.notifyBackendModuleShown();
            }
        });
    }
    else
    {
        this.mContainer.css({ opacity: 0 });
        this.mContainer.velocity("finish", true).velocity({ opacity: 1 },
        {
            duration: Constants.SCREEN_FADE_IN_OUT_DELAY,
            easing: 'swing',
            begin: function ()
            {
                $(this).removeClass('display-none').addClass('display-block');
                self.notifyBackendModuleAnimating();
            },
            complete: function ()
            {
                self.mIsVisible = true;
                self.notifyBackendModuleShown();
            }
        });
    }
};

WorldTownScreenTavernDialogModule.prototype.hide = function ()
{
    var self = this;

    var offset = -(this.mContainer.parent().width() + this.mContainer.width());
    this.mContainer.velocity("finish", true).velocity({ opacity: 0, left: offset },
    {
        duration: Constants.SCREEN_SLIDE_IN_OUT_DELAY,
        easing: 'swing',
        begin: function ()
        {
            $(this).removeClass('is-center');
            self.notifyBackendModuleAnimating();
        },
        complete: function ()
        {
            self.mIsVisible = false;
            $(this).removeClass('display-block').addClass('display-none');
            self.notifyBackendModuleHidden();
        }
    });
};

WorldTownScreenTavernDialogModule.prototype.isVisible = function ()
{
    return this.mIsVisible;
};

WorldTownScreenTavernDialogModule.prototype.updateAssets = function (_data)
{
	this.mAssets.loadFromData(_data);
}

WorldTownScreenTavernDialogModule.prototype.loadFromData = function (_data)
{
	if(_data === undefined || _data === null)
    {
        return;
    }

	if('Title' in _data && _data.Title !== null)
	{
		 this.mDialogContainer.findDialogTitle().html(_data.Title);
	}

	if('SubTitle' in _data && _data.SubTitle !== null)
	{
		 this.mDialogContainer.findDialogSubTitle().html(_data.SubTitle);
	}

	if('LeftInfo' in _data && _data.LeftInfo !== null)
	{
		var parsedText = XBBCODE.process({
				text: _data.LeftInfo,
				removeMisalignedTags: false,
				addInLineBreaks: false
			});

		this.mLeftDetailsPanel.Info.html(parsedText.html);
	}

	if('RightInfo' in _data && _data.RightInfo !== null)
	{
		var parsedText = XBBCODE.process({
				text: _data.RightInfo,
				removeMisalignedTags: false,
				addInLineBreaks: false
			});

		this.mRightDetailsPanel.Info.html(parsedText.html);
	}

	if('Rumor' in _data && _data.Rumor !== null)
	{
		this.updateRumor(_data.Rumor);
	}
	else
	{
		this.mLeftDetailsPanel.Result.empty();
	}

	if('Drink' in _data && _data.Drink !== null)
	{
		this.updateDrinking(_data.Drink);
	}
	else
	{
		this.mRightDetailsPanel.Result.empty();
	}

	this.updateButtons(_data);
};

WorldTownScreenTavernDialogModule.prototype.notifyBackendModuleShown = function ()
{
    if(this.mSQHandle !== null)
    {
        SQ.call(this.mSQHandle, 'onModuleShown');
    }
};

WorldTownScreenTavernDialogModule.prototype.notifyBackendModuleHidden = function ()
{
    if(this.mSQHandle !== null)
    {
        SQ.call(this.mSQHandle, 'onModuleHidden');
    }
};

WorldTownScreenTavernDialogModule.prototype.notifyBackendModuleAnimating = function ()
{
    if(this.mSQHandle !== null)
    {
        SQ.call(this.mSQHandle, 'onModuleAnimating');
    }
};

WorldTownScreenTavernDialogModule.prototype.notifyBackendLeaveButtonPressed = function ()
{
	if(this.mSQHandle !== null)
    {
		SQ.call(this.mSQHandle, 'onLeaveButtonPressed');
	}
};

WorldTownScreenTavernDialogModule.prototype.notifyBackendBrothersButtonPressed = function ()
{
    if(this.mSQHandle !== null)
    {
        SQ.call(this.mSQHandle, 'onBrothersButtonPressed');
    }
};

WorldTownScreenTavernDialogModule.prototype.notifyBackendQueryRumor = function ()
{
    var self = this;
    SQ.call(this.mSQHandle, 'onQueryRumor', null, function (data)
    {
        self.mAssets.loadFromData(data.Assets);
        self.updateRumor(data.Rumor, data.Price);
        self.updateButtons(data);
    });
};


WorldTownScreenTavernDialogModule.prototype.notifyBackendDrink = function ()
{
    var self = this;
    SQ.call(this.mSQHandle, 'onDrink', null, function(data)
    {
	    self.mAssets.loadFromData(data.Assets);
	    self.updateDrinking(data.Drink, data.Price);
	    self.updateButtons(data);
    });
};