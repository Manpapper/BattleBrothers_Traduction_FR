
"use strict";

var WorldTownScreenTravelDialogModule = function(_parent)
{
	this.mSQHandle = null;
    this.mParent = _parent;

	this.mRoster = null;

    // event listener
    this.mEventListener = null;

	// generic containers
	this.mContainer = null;
    this.mDialogContainer = null;
    this.mListContainer = null;
    this.mListScrollContainer = null;
    this.mDetailsPanel = {
        Container: null,
        DestinationImage: null,
        DestinationName: null,
        DestinationBackgroundTextContainer: null,
        DestinationBackgroundTextScrollContainer: null,
        MoneyCostText: null,
        TravelButton: null
    };

    // assets labels
	this.mAssets = new WorldTownScreenAssets(_parent);

    // buttons
    this.mLeaveButton = null;

    // generics
    this.mIsVisible = false;

    // selected entry
    this.mSelectedEntry = null;
};


WorldTownScreenTravelDialogModule.prototype.isConnected = function ()
{
    return this.mSQHandle !== null;
};

WorldTownScreenTravelDialogModule.prototype.onConnection = function (_handle)
{
	//if (typeof(_handle) == 'string')
	{
		this.mSQHandle = _handle;

        // notify listener
        if (this.mEventListener !== null && ('onModuleOnConnectionCalled' in this.mEventListener)) {
            this.mEventListener.onModuleOnConnectionCalled(this);
        }
	}
};

WorldTownScreenTravelDialogModule.prototype.onDisconnection = function ()
{
	this.mSQHandle = null;

    // notify listener
    if (this.mEventListener !== null && ('onModuleOnDisconnectionCalled' in this.mEventListener)) {
        this.mEventListener.onModuleOnDisconnectionCalled(this);
    }
};

WorldTownScreenTravelDialogModule.prototype.createDIV = function (_parentDiv)
{
    var self = this;

    // create: containers (init hidden!)
    this.mContainer = $('<div class="l-travel-dialog-container display-none opacity-none"/>');
    _parentDiv.append(this.mContainer);
    this.mDialogContainer = this.mContainer.createDialog('', '', '', true, 'dialog-1024-768');

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
    var listContainerLayout = $('<div class="l-list-container"/>');
    column.append(listContainerLayout);
    this.mListContainer = listContainerLayout.createList(1.77/*8.85*/);
    this.mListScrollContainer = this.mListContainer.findListScrollContainer();

    // right column
    column = $('<div class="column is-right"/>');
    content.append(column);

    // details container
    var detailsFrame = $('<div class="l-details-frame"/>');
    column.append(detailsFrame);
    this.mDetailsPanel.Container = $('<div class="details-container display-none"/>');
    detailsFrame.append(this.mDetailsPanel.Container);

    // details: destination container
    var detailsRow = $('<div class="row is-destination-container"/>');
    this.mDetailsPanel.Container.append(detailsRow);
    var detailsColumn = $('<div class="column is-destination-portrait-container"/>');
    detailsRow.append(detailsColumn);
    this.mDetailsPanel.DestinationImage = detailsColumn.createImage(null, function (_image)
	{
        var offsetX = 0;
        var offsetY = 0;

        if(self.mSelectedEntry !== null)
        {
            var data = self.mSelectedEntry.data('entry');
            if('ImageOffsetX' in data && data['ImageOffsetX'] !== null &&
                'ImageOffsetY' in data && data['ImageOffsetY'] !== null)
            {
                offsetX = data['ImageOffsetX'];
                offsetY = data['ImageOffsetY'];
            }
        }

        _image.centerImageWithinParent(offsetX, offsetY, 1.0);
        _image.removeClass('opacity-none');
    }, null, 'opacity-none');
    detailsColumn = $('<div class="column is-destination-background-container"/>');
    detailsRow.append(detailsColumn);

    // details: background
    var backgroundRow = $('<div class="row is-top"/>');
    detailsColumn.append(backgroundRow);
	var backgroundRowBorder = $('<div class="row is-top border"/>');
	backgroundRow.append(backgroundRowBorder);

    this.mDetailsPanel.DestinationName = $('<div class="name title-font-normal font-bold font-color-brother-name"/>');
    backgroundRow.append(this.mDetailsPanel.DestinationName);
    backgroundRow = $('<div class="row is-bottom"/>');
    detailsColumn.append(backgroundRow);
    this.mDetailsPanel.DestinationBackgroundTextContainer = backgroundRow.createList(20, 'description-font-medium font-bottom-shadow font-color-description', true);
    this.mDetailsPanel.DestinationBackgroundTextScrollContainer = this.mDetailsPanel.DestinationBackgroundTextContainer.findListScrollContainer();

    // details: costs
    detailsRow = $('<div class="row is-costs-container"/>');
    this.mDetailsPanel.Container.append(detailsRow);
    var costsHeader = $('<div class="row is-header"/>');
    detailsRow.append(costsHeader);
    var costsHeaderLabel = $('<div class="label title-font-normal font-bold font-bottom-shadow font-color-title">Prix</div>');
    costsHeader.append(costsHeaderLabel);
    
	var costsInitial = $('<div class="row is-initial-cost"/>');
    detailsRow.append(costsInitial);
    var costsLabel = $('<div class="costs-label title-font-normal font-bold font-bottom-shadow font-color-title">Paiement Direct</div>');
    costsInitial.append(costsLabel);
    var costsContainer = $('<div class="l-costs-container"/>');
    costsInitial.append(costsContainer);
    var costsImage = $('<img/>');
    costsImage.attr('src', Path.GFX + Asset.ICON_ASSET_MONEY);
    costsContainer.append(costsImage);
    costsImage.bindTooltip({ contentType: 'ui-element', elementId: TooltipIdentifier.Assets.Fee });
    this.mDetailsPanel.MoneyCostText = $('<div class="label text-font-normal font-bottom-shadow font-color-description"/>');
    costsContainer.append(this.mDetailsPanel.MoneyCostText);

    // details: buttons
    detailsRow = $('<div class="row is-button-container"/>');
    this.mDetailsPanel.Container.append(detailsRow);
    var TravelButtonLayout = $('<div class="l-travel-button"/>');
    detailsRow.append(TravelButtonLayout);
    this.mDetailsPanel.TravelButton = TravelButtonLayout.createTextButton("Voyager", function()
	{
        if(self.mSelectedEntry !== null)
        {
            var data = self.mSelectedEntry.data('entry');
            if('EntryID' in data && data['EntryID'] !== null)
            {
                self.travelToEntry(data['EntryID']);
            }
        }
    }, '', 1);

    // create footer button bar
    var footerButtonBar = $('<div class="l-button-bar"/>');
    this.mDialogContainer.findDialogFooterContainer().append(footerButtonBar);

    // create: buttons
    var layout = $('<div class="l-leave-button"/>');
    footerButtonBar.append(layout);
    this.mLeaveButton = layout.createTextButton("Quitter", function()
	{
        self.notifyBackendLeaveButtonPressed();
    }, '', 1);

    this.mIsVisible = false;
};

WorldTownScreenTravelDialogModule.prototype.destroyDIV = function ()
{
	this.mAssets.destroyDIV();

	this.mSelectedEntry = null;

    this.mDetailsPanel.TravelButton.remove();
    this.mDetailsPanel.TravelButton = null;

    this.mDetailsPanel.MoneyCostText.empty();
    this.mDetailsPanel.MoneyCostText.remove();
    this.mDetailsPanel.MoneyCostText = null;

    this.mDetailsPanel.DestinationBackgroundTextScrollContainer.empty();
    this.mDetailsPanel.DestinationBackgroundTextScrollContainer = null;
    this.mDetailsPanel.DestinationBackgroundTextContainer.destroyList();
    this.mDetailsPanel.DestinationBackgroundTextContainer.remove();
    this.mDetailsPanel.DestinationBackgroundTextContainer = null;

    this.mDetailsPanel.DestinationName.empty();
    this.mDetailsPanel.DestinationName.remove();
    this.mDetailsPanel.DestinationName = null;

    this.mDetailsPanel.DestinationImage.empty();
    this.mDetailsPanel.DestinationImage.remove();
    this.mDetailsPanel.DestinationImage = null;

    this.mDetailsPanel.Container.empty();
    this.mDetailsPanel.Container.remove();
    this.mDetailsPanel.Container = null;

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

WorldTownScreenTravelDialogModule.prototype.addListEntry = function (_data)
{
    var result = $('<div class="l-row"/>');
    this.mListScrollContainer.append(result);

    var entry = $('<div class="ui-control list-entry"/>');
    result.append(entry);
    entry.data('entry', _data);
    entry.click(this, function(_event)
	{
        var self = _event.data;
        self.selectListEntry($(this));
    });

    // left column
    var column = $('<div class="column is-left"/>');
    entry.append(column);

    var imageOffsetX = ('ImageOffsetX' in _data ? _data['ImageOffsetX'] : 0);
    var imageOffsetY = ('ImageOffsetY' in _data ? _data['ImageOffsetY'] : 0);
    column.createImage(Path.GFX + _data['ListImagePath'], function (_image)
	{
        _image.centerImageWithinParent(imageOffsetX, imageOffsetY, 0.64);
        _image.removeClass('opacity-none');
    }, null, 'opacity-none');

    // right column
    column = $('<div class="column is-right"/>');

    if(_data['FactionImagePath'] !== null)
    {
    	column.createImage(Path.GFX + _data['FactionImagePath'], function (_image)
    	{
    		_image.centerImageWithinParent(imageOffsetX, imageOffsetY, 0.64);
    		_image.removeClass('opacity-none');
    	}, null, 'opacity-none  is-banner');
    }
    entry.append(column);

    // top row
    var row = $('<div class="row is-top"/>');
    column.append(row);

//     var image = $('<img/>');
//     image.attr('src', Path.GFX + _data['BackgroundImagePath']);
//     row.append(image);

    // bind tooltip
   // image.bindTooltip({ contentType: 'ui-element', elementId: TooltipIdentifier.CharacterBackgrounds.Generic, elementOwner: TooltipIdentifier.ElementOwner.HireScreen, entityId: _data[WorldTownScreenIdentifier.travelToEntry.Id] });

    var name = $('<div class="name title-font-normal font-bold font-color-brother-name">' + _data['ListName'] + '</div>');
    row.append(name);

    // bottom row
    row = $('<div class="row is-bottom"/>');
    column.append(row);

    var assetsCenterContainer = $('<div class="l-assets-center-container"/>');
    row.append(assetsCenterContainer);

    // initial money
    var assetsContainer = $('<div class="l-assets-container"/>');
    assetsCenterContainer.append(assetsContainer);
    var image = $('<img/>');
    image.attr('src', Path.GFX + Asset.ICON_ASSET_MONEY);
    assetsContainer.append(image);
    //image.bindTooltip({ contentType: 'ui-element', elementId: TooltipIdentifier.Assets.Fee });
    var text = $('<div class="label is-initial-cost text-font-normal font-color-subtitle">' + Helper.numberWithCommas(_data['Cost']) + '</div>');
    assetsContainer.append(text);
};

WorldTownScreenTravelDialogModule.prototype.selectListEntry = function(_element, _scrollToEntry)
{
    if (_element !== null && _element.length > 0)
    {
        // check if this is already selected
        //if (_element.hasClass('is-selected') !== true)
        {
            this.mListContainer.deselectListEntries();
            _element.addClass('is-selected');

            // give the renderer some time to layout his shit...
            if (_scrollToEntry !== undefined && _scrollToEntry === true)
            {
                this.mListContainer.scrollListToElement(_element);
            }

            this.mSelectedEntry = _element;
            this.updateDetailsPanel(this.mSelectedEntry);
            this.updateListEntryValues();
        }
    }
    else
    {
        this.mSelectedEntry = null;
        this.updateDetailsPanel(this.mSelectedEntry);
        this.updateListEntryValues();
    }
};

WorldTownScreenTravelDialogModule.prototype.updateDetailsPanel = function(_element)
{
    if(_element !== null && _element.length > 0)
    {
        var currentMoney = this.mAssets.getValues().Money;
        var data = _element.data('entry');
        var initialMoneyCost = (data !== null && 'Cost' in data ? data['Cost'] : 0);
        
        this.mDetailsPanel.DestinationImage.attr('src', Path.GFX + data['ImagePath']);     
       
        // retarded JS calls load callback after a significant delay only - so we call this here manually to position/resize an image that is completely loaded already anyway
        this.mDetailsPanel.DestinationImage.centerImageWithinParent(0, 0, 1.0); 
       
// 		var parsedDescriptionText = XBBCODE.process({
// 			text: data['BackgroundText'],
// 			removeMisalignedTags: false,
// 			addInLineBreaks: true
// 		});

        this.mDetailsPanel.DestinationName.html(data['Name']);
        this.mDetailsPanel.DestinationBackgroundTextScrollContainer.html(data['BackgroundText']);
        this.mDetailsPanel.MoneyCostText.html(Helper.numberWithCommas(data['Cost']));

        // special cases for not enough resources
        if((currentMoney - initialMoneyCost) < 0)
        {
            this.mDetailsPanel.MoneyCostText.removeClass('font-color-description').addClass('font-color-assets-negative-value');
            this.mDetailsPanel.TravelButton.enableButton(false);
        }
        else
        {
            this.mDetailsPanel.TravelButton.enableButton(true);
            this.mDetailsPanel.MoneyCostText.removeClass('font-color-assets-negative-value').addClass('font-color-description');
        }

        this.mDetailsPanel.Container.removeClass('display-none').addClass('display-block');
    }
    else
    {
        this.mDetailsPanel.Container.removeClass('display-block').addClass('display-none');
    }
};

WorldTownScreenTravelDialogModule.prototype.updateListEntryValues = function()
{
    var currentMoney = this.mAssets.getValues().Money;
    var container = this.mListContainer.findListScrollContainer();
    container.find('.list-entry').each(function(index, element)
	{
        var entry = $(element);
        var initialMoneyCostElement = entry.find('.is-initial-cost');
        var data = entry.data('entry');
        var initialMoneyCost = (data !== null && 'Cost' in data ? data['Cost'] : 0);
        if((currentMoney - initialMoneyCost) < 0)
        {
            initialMoneyCostElement.removeClass('font-color-subtitle').addClass('font-color-assets-negative-value');
        }
        else
        {
            initialMoneyCostElement.removeClass('font-color-assets-negative-value').addClass('font-color-subtitle');
        }
    });
};

WorldTownScreenTravelDialogModule.prototype.bindTooltips = function ()
{
    this.mAssets.bindTooltips();
    this.mLeaveButton.bindTooltip({ contentType: 'ui-element', elementId: TooltipIdentifier.WorldTownScreen.TravelDialogModule.LeaveButton });
    this.mDetailsPanel.TravelButton.bindTooltip({ contentType: 'ui-element', elementId: TooltipIdentifier.WorldTownScreen.TravelDialogModule.TravelButton });
};

WorldTownScreenTravelDialogModule.prototype.unbindTooltips = function ()
{
	this.mAssets.unbindTooltips();
    this.mLeaveButton.unbindTooltip();
    this.mDetailsPanel.TravelButton.unbindTooltip();
};


WorldTownScreenTravelDialogModule.prototype.create = function(_parentDiv)
{
    this.createDIV(_parentDiv);
    this.bindTooltips();
};

WorldTownScreenTravelDialogModule.prototype.destroy = function()
{
    this.unbindTooltips();
    this.destroyDIV();
};


WorldTownScreenTravelDialogModule.prototype.register = function (_parentDiv)
{
    console.log('WorldTownScreenTravelDialogModule::REGISTER');

    if (this.mContainer !== null)
    {
        console.error('ERROR: Failed to register Travel Dialog Module. Reason: Already initialized.');
        return;
    }

    if (_parentDiv !== null && typeof(_parentDiv) == 'object')
    {
        this.create(_parentDiv);
    }
};

WorldTownScreenTravelDialogModule.prototype.unregister = function ()
{
    console.log('WorldTownScreenTravelDialogModule::UNREGISTER');

    if (this.mContainer === null)
    {
        console.error('ERROR: Failed to unregister Travel Dialog Module. Reason: Not initialized.');
        return;
    }

    this.destroy();
};

WorldTownScreenTravelDialogModule.prototype.isRegistered = function ()
{
    if (this.mContainer !== null)
    {
        return this.mContainer.parent().length !== 0;
    }

    return false;
};


WorldTownScreenTravelDialogModule.prototype.registerEventListener = function(_listener)
{
    this.mEventListener = _listener;
};


WorldTownScreenTravelDialogModule.prototype.show = function (_withSlideAnimation)
{
    var self = this;

    var withAnimation = (_withSlideAnimation !== undefined && _withSlideAnimation !== null) ? _withSlideAnimation : true;
    if (withAnimation === true)
    {
        var offset = -(this.mContainer.parent().width() + this.mContainer.width());
        this.mContainer.css({ 'left': offset });
        this.mContainer.velocity("finish", true).velocity({ opacity: 1, left: '0', right: '0' }, {
            duration: Constants.SCREEN_SLIDE_IN_OUT_DELAY,
            easing: 'swing',
            begin: function () {
                $(this).removeClass('display-none').addClass('display-block');
                self.notifyBackendModuleAnimating();
            },
            complete: function () {
                self.mIsVisible = true;
                self.notifyBackendModuleShown();
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
                self.notifyBackendModuleAnimating();
            },
            complete: function() {
                self.mIsVisible = true;
                self.notifyBackendModuleShown();
            }
        });
    }
};

WorldTownScreenTravelDialogModule.prototype.hide = function ()
{
    var self = this;

    var offset = -(this.mContainer.parent().width() + this.mContainer.width());
    this.mContainer.velocity("finish", true).velocity({ opacity: 0, left: offset }, {
        duration: Constants.SCREEN_SLIDE_IN_OUT_DELAY,
        easing: 'swing',
        begin: function() {
            $(this).removeClass('is-center');
            self.notifyBackendModuleAnimating();
        },
        complete: function() {
            self.mIsVisible = false;
            $(this).removeClass('display-block').addClass('display-none');
            self.notifyBackendModuleHidden();
        }
    });
};

WorldTownScreenTravelDialogModule.prototype.isVisible = function ()
{
    return this.mIsVisible;
};


WorldTownScreenTravelDialogModule.prototype.updateAssets = function (_data)
{
	this.mAssets.loadFromData(_data);
	this.updateListEntryValues();
}

WorldTownScreenTravelDialogModule.prototype.loadFromData = function (_data)
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

	if('HeaderImage' in _data && _data.HeaderImage !== null)
	{
		 this.mDialogContainer.findDialogHeaderImage().attr('src', Path.GFX + _data.HeaderImage);
	}

	this.mRoster = _data.Roster;

    this.mListScrollContainer.empty();

    for(var i = 0; i < _data.Roster.length; ++i)
    {
		var entry = _data.Roster[i];
        this.addListEntry(entry);
    }

    this.selectListEntry(this.mListContainer.findListEntryByIndex(0), true);
};


WorldTownScreenTravelDialogModule.prototype.travelToEntry = function (_entryID)
{
    var self = this;
    this.notifyBackendTravel(_entryID, function(data)
    {
    	// error?
    	if(data.Result != 0)
    	{
    		if(data.Result == ErrorCode.NotEnoughMoney)
    		{
    			this.mAssets.mMoneyAsset.shakeLeftRight();
    		}
    		else
    		{
    			console.error("Failed to travel. Reason: Unknown");
    		}
    		
    		return;
    	}

    	// update assets
    	self.mParent.loadAssetData(data.Assets);
    });
};

WorldTownScreenTravelDialogModule.prototype.notifyBackendModuleShown = function ()
{
    SQ.call(this.mSQHandle, 'onModuleShown');
};

WorldTownScreenTravelDialogModule.prototype.notifyBackendModuleHidden = function ()
{
    SQ.call(this.mSQHandle, 'onModuleHidden');
};

WorldTownScreenTravelDialogModule.prototype.notifyBackendModuleAnimating = function ()
{
    SQ.call(this.mSQHandle, 'onModuleAnimating');
};

WorldTownScreenTravelDialogModule.prototype.notifyBackendLeaveButtonPressed = function ()
{
    SQ.call(this.mSQHandle, 'onLeaveButtonPressed');
};

WorldTownScreenTravelDialogModule.prototype.notifyBackendTravel = function (_entryID, _callback)
{
    SQ.call(this.mSQHandle, 'onTravel', _entryID, _callback);
};