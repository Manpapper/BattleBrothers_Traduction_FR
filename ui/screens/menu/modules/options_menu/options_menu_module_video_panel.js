/*
 *  @Project:		Battle Brothers
 *	@Company:		Overhype Studios
 *
 *	@Copyright:		(c) Overhype Studios | 2013 - 2020
 * 
 *  @Author:		Overhype Studios
 *  @Date:			12.04.2017 (refactored: 03.10.2017)
 *  @Description:	Options Menu Module - Video Panel JS
 */
"use strict";


var OptionsMenuModuleVideoPanel = function(_dataSource)
{
	this.mDataSource  = _dataSource;
 
	// container
	this.mContainer = null;
    this.mListContainer = null;
    this.mListScrollContainer = null;

	// controls
	this.mFullscreenCheckbox	= null;
	this.mWindowCheckbox		= null;
	this.mBorderlessCheckbox	= null;
	this.mVSyncCheckbox			= null;
	this.mDepthOfFieldCheckbox	= null;
	this.mDepthOfFieldLabel		= null;

	this.mUIScale				= null;
	this.mUIScaleLabel			= null;

	this.mSpriteScale			= null;
	this.mSpriteScaleLabel		= null;

	this.mIsSystemChange		= false;

    this.registerDatasourceListener();
};


OptionsMenuModuleVideoPanel.prototype.createDIV = function (_parentDiv)
{
	var self = this;

	// create: character panel (init hidden!)
	this.mContainer = $('<div class="video-panel display-none"/>');
    _parentDiv.append(this.mContainer);

	// create: columns
	var leftColumn = $('<div class="column"/>');
	this.mContainer.append(leftColumn);
	var rightColumn = $('<div class="column"/>');
	this.mContainer.append(rightColumn);

	// create: resolution list
	var resolutionsRow = $('<div class="row"/>');
	leftColumn.append(resolutionsRow);
	var resolutionsTile = $('<div class="title title-font-big font-bold font-color-title">Resolution</div>');
	resolutionsRow.append(resolutionsTile);

    var listContainerLayout = $('<div class="control l-list-container"/>');
    resolutionsRow.append(listContainerLayout);
    this.mListContainer = listContainerLayout.createList(0.635);
    this.mListScrollContainer = this.mListContainer.findListScrollContainer();

	// create: display options
	var displayRow = $('<div class="row"/>');
	rightColumn.append(displayRow);
	var displayTile = $('<div class="title title-font-big font-bold font-color-title">Display</div>');
	displayRow.append(displayTile);
	
	var fullscreenControl = $('<div class="control"/>');
	displayRow.append(fullscreenControl);
	this.mFullscreenCheckbox = $('<input type="radio" id="cb-fullscreen" name="display"/>');
	fullscreenControl.append(this.mFullscreenCheckbox);
	var fullscreenCheckboxLabel = $('<label class="text-font-normal font-color-subtitle" for="cb-fullscreen">Fullscreen</label>');
	fullscreenControl.append(fullscreenCheckboxLabel);
	this.mFullscreenCheckbox.iCheck({
		checkboxClass: 'icheckbox_flat-orange',
		radioClass: 'iradio_flat-orange',
		increaseArea: '30%'
    });

	var windowControl = $('<div class="control"/>');
	displayRow.append(windowControl);
	this.mWindowCheckbox = $('<input type="radio" id="cb-window" name="display"/>');
	windowControl.append(this.mWindowCheckbox);
	var borderlessCheckboxLabel = $('<label class="text-font-normal font-color-subtitle" for="cb-window">Window</label>');
	windowControl.append(borderlessCheckboxLabel);
	this.mWindowCheckbox.iCheck({
		checkboxClass: 'icheckbox_flat-orange',
		radioClass: 'iradio_flat-orange',
		increaseArea: '30%'
    });

	var borderlessControl = $('<div class="control"/>');
	displayRow.append(borderlessControl);
	this.mBorderlessCheckbox = $('<input type="radio" id="cb-borderless" name="display"/>');
	borderlessControl.append(this.mBorderlessCheckbox);
	borderlessCheckboxLabel = $('<label class="text-font-normal font-color-subtitle" for="cb-borderless">Borderless Window</label>');
	borderlessControl.append(borderlessCheckboxLabel);
	this.mBorderlessCheckbox.iCheck({
		checkboxClass: 'icheckbox_flat-orange',
		radioClass: 'iradio_flat-orange',
		increaseArea: '30%'
    });

	var vsyncControl = $('<div class="control"/>');
	displayRow.append(vsyncControl);
	this.mVSyncCheckbox = $('<input type="checkbox" id="cb-vsync"/>');
	vsyncControl.append(this.mVSyncCheckbox);
	var vsyncCheckboxLabel = $('<label class="text-font-normal font-color-subtitle" for="cb-vsync">VSync</label>');
	vsyncControl.append(vsyncCheckboxLabel);
	this.mVSyncCheckbox.iCheck({
		checkboxClass: 'icheckbox_flat-orange',
		radioClass: 'iradio_flat-orange',
		increaseArea: '30%'
    });

	// create: detail options
	var detailRow = $('<div class="row"/>');
	rightColumn.append(detailRow);
	var detailTile = $('<div class="title title-font-big font-bold font-color-title">Detail</div>');
	detailRow.append(detailTile);

	var depthOfFieldControl = $('<div class="control"/>');
	detailRow.append(depthOfFieldControl);
	this.mDepthOfFieldCheckbox = $('<input type="checkbox" id="cb-depth-of-field"/>');
	depthOfFieldControl.append(this.mDepthOfFieldCheckbox);
	var depthOfFieldCheckboxLabel = $('<label class="text-font-normal font-color-subtitle" for="cb-depth-of-field">Depth of Field</label>');
	this.mDepthOfFieldLabel = depthOfFieldCheckboxLabel;
	depthOfFieldControl.append(depthOfFieldCheckboxLabel);
	this.mDepthOfFieldCheckbox.iCheck({
		checkboxClass: 'icheckbox_flat-orange',
		radioClass: 'iradio_flat-orange',
		increaseArea: '30%'
	});

	// create: ui scaling options
	var scalingRow = $('<div class="row"/>');
	rightColumn.append(scalingRow);
	var scalingTile = $('<div class="title title-font-big font-bold font-color-title">UI Scale</div>');
	scalingRow.append(scalingTile);

	var scaleControl = $('<div class="scale-control"/>');
	scalingRow.append(scaleControl);

	this.mUIScaleLabel = $('<div class="scale-label text-font-normal font-color-subtitle">100%</div>');
	scaleControl.append(this.mUIScaleLabel);

	this.mUIScale = $('<input class="scale-slider" type="range" min="100" max="200" step="10" />');
	scaleControl.append(this.mUIScale);

	this.mUIScale.on("change", function ()
	{
		if(!self.mIsSystemChange)
		{
			var value = parseInt(self.mUIScale.val());
			self.mDataSource.updateVideoOption(OptionsMenuModuleIdentifier.QueryResult.Video.UIScaling.Key, value);
		}

		self.mUIScaleLabel.text('' + parseInt(self.mUIScale.val()) + '%');
	});

	// create: sprite scaling options
	var scalingRow = $('<div class="row"/>');
	rightColumn.append(scalingRow);
	var scalingTile = $('<div class="title title-font-big font-bold font-color-title">Scene Scale</div>');
	scalingRow.append(scalingTile);

	var scaleControl = $('<div class="scale-control"/>');
	scalingRow.append(scaleControl);

	this.mSpriteScaleLabel = $('<div class="scale-label text-font-normal font-color-subtitle">100%</div>');
	scaleControl.append(this.mSpriteScaleLabel);

	this.mSpriteScale = $('<input class="scale-slider" type="range" min="100" max="200" step="10" />');
	scaleControl.append(this.mSpriteScale);

	this.mSpriteScale.on("change", function ()
	{
		if (!self.mIsSystemChange)
		{
			var value = parseInt(self.mSpriteScale.val());
			self.mDataSource.updateVideoOption(OptionsMenuModuleIdentifier.QueryResult.Video.SpriteScaling.Key, value);
		}

		self.mSpriteScaleLabel.text('' + parseInt(self.mSpriteScale.val()) + '%');
	});

	var thanksMike = $('<div class="control thanks-mike"/>');
	resolutionsRow.append(thanksMike);

	var thanksImage = $('<img class="" src="' + Path.GFX + 'ui/tooltips/warning.png" />');
	thanksMike.append(thanksImage);

	var thanksLabel = $('<label class="text-font-normal font-color-brother-name">Changes take effect after restart!</label>');
	thanksMike.append(thanksLabel);

    this.setupEventHandler();
};

OptionsMenuModuleVideoPanel.prototype.destroyDIV = function ()
{
    // controls
    this.mFullscreenCheckbox.remove();
    this.mFullscreenCheckbox = null;
    this.mWindowCheckbox.remove();
    this.mWindowCheckbox = null;
    this.mBorderlessCheckbox.remove();
    this.mBorderlessCheckbox = null;
    this.mVSyncCheckbox.remove();
    this.mVSyncCheckbox = null;
    this.mDepthOfFieldCheckbox.remove();
    this.mDepthOfFieldCheckbox = null;

    this.mListContainer.destroyList();
    this.mListScrollContainer = null;
    this.mListContainer = null;

    this.mContainer.empty();
    this.mContainer.remove();
    this.mContainer = null;
};


OptionsMenuModuleVideoPanel.prototype.setupEventHandler = function ()
{
	//this.removeEventHandler();

	this.mFullscreenCheckbox.on('ifChecked', null, this, function (_event)
	{
		var self = _event.data;
		self.mDataSource.updateVideoOption(OptionsMenuModuleIdentifier.QueryResult.Video.WindowMode.Key, OptionsMenuModuleIdentifier.QueryResult.Video.WindowMode.Fullscreen);
	});

	this.mWindowCheckbox.on('ifChecked', null, this, function (_event)
	{
		var self = _event.data;
		self.mDataSource.updateVideoOption(OptionsMenuModuleIdentifier.QueryResult.Video.WindowMode.Key, OptionsMenuModuleIdentifier.QueryResult.Video.WindowMode.Window);
    });

	this.mBorderlessCheckbox.on('ifChecked', null, this, function (_event)
	{
		var self = _event.data;
		self.mDataSource.updateVideoOption(OptionsMenuModuleIdentifier.QueryResult.Video.WindowMode.Key, OptionsMenuModuleIdentifier.QueryResult.Video.WindowMode.Borderless);
    });

    this.mVSyncCheckbox.on('ifChecked ifUnchecked', null, this, function (_event)
    {
		var self = _event.data;
		self.mDataSource.updateVideoOption(OptionsMenuModuleIdentifier.QueryResult.Video.VSync, self.mVSyncCheckbox.prop('checked') === true);
    });

    this.mDepthOfFieldCheckbox.on('ifChecked ifUnchecked', null, this, function (_event)
    {
		var self = _event.data;
		self.mDataSource.updateVideoOption(OptionsMenuModuleIdentifier.QueryResult.Video.DepthOfField, self.mDepthOfFieldCheckbox.prop('checked') === true);
    });
};


OptionsMenuModuleVideoPanel.prototype.bindTooltips = function ()
{
	this.mDepthOfFieldLabel.bindTooltip({ contentType: 'ui-element', elementId: TooltipIdentifier.MenuScreen.Options.DepthOfField });
	this.mUIScale.bindTooltip({ contentType: 'ui-element', elementId: TooltipIdentifier.MenuScreen.Options.UIScale });
	this.mSpriteScale.bindTooltip({ contentType: 'ui-element', elementId: TooltipIdentifier.MenuScreen.Options.SceneScale });
};

OptionsMenuModuleVideoPanel.prototype.unbindTooltips = function ()
{
	this.mDepthOfFieldLabel.unbindTooltip();
	this.mUIScale.unbindTooltip();
	this.mSpriteScale.unbindTooltip();
};


OptionsMenuModuleVideoPanel.prototype.addResolutionToList = function (_data, _index)
{
	if (_data === null || 
		!(OptionsMenuModuleIdentifier.QueryResult.Video.Resolution.Width in _data) ||
		!(OptionsMenuModuleIdentifier.QueryResult.Video.Resolution.Height in _data) ||
		!(OptionsMenuModuleIdentifier.QueryResult.Video.Resolution.Bpp in _data) )
	{
		console.error('ERROR: Failed to add resolution. Reason: Invalid data.');
		return;
	}

	var label = '' + _data[OptionsMenuModuleIdentifier.QueryResult.Video.Resolution.Width] + ' x ' +
					_data[OptionsMenuModuleIdentifier.QueryResult.Video.Resolution.Height];

    var row = $('<div class="l-row"/>');
	var entry = $('<div id="resolution-' + _index + '" class="ui-control list-entry list-entry-small"><span class="label text-font-medium font-color-label">' + label + '</span></div></div>');
    entry.data('resolution', _index);
    entry.click(this, function (_event)
    {
		var self = _event.data;
		self.selectResolution($(this));
	});
    row.append(entry);
	this.mListScrollContainer.append(row);
};

OptionsMenuModuleVideoPanel.prototype.addResolutionsToList = function (_data)
{
	if (_data !== null && jQuery.isArray(_data))
	{
        this.mListScrollContainer.empty();

		for (var i = 0; i < _data.length; ++i)
		{
			this.addResolutionToList(_data[i], i);
		}
	}
};

OptionsMenuModuleVideoPanel.prototype.deselectResolutions = function()
{
	this.mListScrollContainer.find('.is-selected').each(function(index, element) {
		$(element).removeClass('is-selected');
	});
};

OptionsMenuModuleVideoPanel.prototype.getSelectedResolutionIndex = function()
{
	var result = -1;

	if (this.mListScrollContainer !== null)
	{
		this.mListScrollContainer.find('.is-selected').each(function(index, element) {
			result = $(element).data('resolution');
			return false;
		});
	}
	
	return result;
};

OptionsMenuModuleVideoPanel.prototype.selectResolution = function(_element, _scrollToResolution)
{
	if (_element !== null && _element.length > 0)
	{
		// check if this is already selected
		//if (_element.hasClass('is-selected') !== true)
		{
			this.deselectResolutions();
			_element.addClass('is-selected');
			
			var self = this;
			// give the renderer some time to layout his shit...
			if (_scrollToResolution !== undefined && _scrollToResolution === true)
			{
                self.mListContainer.scrollListToElement(_element);
			}

			this.mDataSource.updateVideoOption(OptionsMenuModuleIdentifier.QueryResult.Video.Resolution.Key, _element.data('resolution'));
		}
	}
};

OptionsMenuModuleVideoPanel.prototype.selectResolutionByIndex = function(_index)
{
	this.selectResolution(this.mListScrollContainer.find('#resolution-' + _index), true);
	this.mListContainer.trigger('update', true);
};

OptionsMenuModuleVideoPanel.prototype.reselectResolution = function()
{
	var idx = this.getSelectedResolutionIndex();
	if (idx >= 0)
	{
		this.selectResolution(this.mListScrollContainer.find('#resolution-' + idx), true);
	}
};

OptionsMenuModuleVideoPanel.prototype.selectWindowModeOptions = function(_data)
{
	if (_data === null || typeof(_data) !== 'string')
	{
		return;
	}

	switch(_data.toLowerCase())
	{
		case OptionsMenuModuleIdentifier.QueryResult.Video.WindowMode.Fullscreen:
		{
			this.mFullscreenCheckbox.iCheck('check');
		} break;
		case OptionsMenuModuleIdentifier.QueryResult.Video.WindowMode.Window:
		{
			this.mWindowCheckbox.iCheck('check');
		} break;
		case OptionsMenuModuleIdentifier.QueryResult.Video.WindowMode.Borderless:
		{
			this.mBorderlessCheckbox.iCheck('check');
		} break;
	}
};

OptionsMenuModuleVideoPanel.prototype.selectUIScalingOption = function (_data)
{
	this.mIsSystemChange = true;

	this.mUIScale.val(_data);
	this.mUIScaleLabel.text('' + parseInt(this.mUIScale.val()) + '%');

	this.mIsSystemChange = false;
};

OptionsMenuModuleVideoPanel.prototype.selectSpriteScalingOption = function (_data)
{
	this.mIsSystemChange = true;

	this.mSpriteScale.val(_data);
	this.mSpriteScaleLabel.text('' + parseInt(this.mSpriteScale.val()) + '%');

	this.mIsSystemChange = false;
};

OptionsMenuModuleVideoPanel.prototype.selectVSyncOption = function(_data)
{
	if (_data === null || typeof(_data) !== 'boolean')
	{
		return;
	}

	this.mVSyncCheckbox.iCheck(_data === true ? 'check' : 'uncheck');
};

OptionsMenuModuleVideoPanel.prototype.selectDepthOfFieldOption = function(_data)
{
	if (_data === null || typeof(_data) !== 'boolean')
	{
		return;
	}

	this.mDepthOfFieldCheckbox.iCheck(_data === true ? 'check' : 'uncheck');
};


OptionsMenuModuleVideoPanel.prototype.registerDatasourceListener = function()
{
	this.mDataSource.addListener(OptionsMenuModuleDatasourceIdentifier.Options.Loaded, jQuery.proxy(this.onOptionsLoaded, this));
	this.mDataSource.addListener(OptionsMenuModuleDatasourceIdentifier.Options.Reseted, jQuery.proxy(this.onDefaultsLoaded, this));
};


OptionsMenuModuleVideoPanel.prototype.create = function(_parentDiv)
{
    this.createDIV(_parentDiv);
    this.bindTooltips();
};

OptionsMenuModuleVideoPanel.prototype.destroy = function()
{
    this.unbindTooltips();
    this.destroyDIV();
};


OptionsMenuModuleVideoPanel.prototype.register = function (_parentDiv)
{
    console.log('OptionsMenuModuleVideoPanel::REGISTER');

    if (this.mContainer !== null)
    {
        console.error('ERROR: Failed to register Video Panel Module. Reason: Video Panel Module is already initialized.');
        return;
    }

    if (_parentDiv !== null && typeof(_parentDiv) == 'object')
    {
        this.create(_parentDiv);
    }
};

OptionsMenuModuleVideoPanel.prototype.unregister = function ()
{
    console.log('OptionsMenuModuleVideoPanel::UNREGISTER');

    if (this.mContainer === null)
    {
        console.error('ERROR: Failed to unregister Video Panel Module. Reason: Video Panel Module is not initialized.');
        return;
    }

    this.destroy();
};

OptionsMenuModuleVideoPanel.prototype.isRegistered = function ()
{
	if (this.mContainer !== null)
	{
		return this.mContainer.parent().length !== 0;
	}

	return false;
};


OptionsMenuModuleVideoPanel.prototype.show = function ()
{
    this.mContainer.removeClass('display-none').addClass('display-block');
	this.reselectResolution();
};

OptionsMenuModuleVideoPanel.prototype.hide = function ()
{
	this.mContainer.removeClass('display-block').addClass('display-none');
};


OptionsMenuModuleVideoPanel.prototype.onOptionsLoaded = function (_dataSource, _data)
{
	// get video options
	var videoOptions = _dataSource.getVideoOptions();
	if (OptionsMenuModuleIdentifier.QueryResult.Video.Resolutions in videoOptions)
	{
		this.addResolutionsToList(videoOptions[OptionsMenuModuleIdentifier.QueryResult.Video.Resolutions]);

		if (OptionsMenuModuleIdentifier.QueryResult.Video.Resolution.Key in videoOptions)
		{
			this.selectResolutionByIndex(videoOptions[OptionsMenuModuleIdentifier.QueryResult.Video.Resolution.Key]);
		}
	}

	if (OptionsMenuModuleIdentifier.QueryResult.Video.WindowMode.Key in videoOptions)
	{
		this.selectWindowModeOptions(videoOptions[OptionsMenuModuleIdentifier.QueryResult.Video.WindowMode.Key]);
	}

	if (OptionsMenuModuleIdentifier.QueryResult.Video.VSync in videoOptions)
	{
		this.selectVSyncOption(videoOptions[OptionsMenuModuleIdentifier.QueryResult.Video.VSync]);
	}

	if (OptionsMenuModuleIdentifier.QueryResult.Video.DepthOfField in videoOptions)
	{
		this.selectDepthOfFieldOption(videoOptions[OptionsMenuModuleIdentifier.QueryResult.Video.DepthOfField]);
	}

	if (OptionsMenuModuleIdentifier.QueryResult.Video.UIScaling.Key in videoOptions)
	{
		this.selectUIScalingOption(videoOptions[OptionsMenuModuleIdentifier.QueryResult.Video.UIScaling.Key]);
	}

	if (OptionsMenuModuleIdentifier.QueryResult.Video.SpriteScaling.Key in videoOptions)
	{
		this.selectSpriteScalingOption(videoOptions[OptionsMenuModuleIdentifier.QueryResult.Video.SpriteScaling.Key]);
	}
};

OptionsMenuModuleVideoPanel.prototype.onDefaultsLoaded = function (_dataSource, _data)
{
	// get video options
	var videoOptions = _dataSource.getDefaultVideoOptions();
	if (OptionsMenuModuleIdentifier.QueryResult.Video.Resolution.Key in videoOptions)
	{
		this.selectResolutionByIndex(videoOptions[OptionsMenuModuleIdentifier.QueryResult.Video.Resolution.Key]);
	}

	if (OptionsMenuModuleIdentifier.QueryResult.Video.WindowMode.Key in videoOptions)
	{
		this.selectWindowModeOptions(videoOptions[OptionsMenuModuleIdentifier.QueryResult.Video.WindowMode.Key]);
	}

	if (OptionsMenuModuleIdentifier.QueryResult.Video.VSync in videoOptions)
	{
		this.selectVSyncOption(videoOptions[OptionsMenuModuleIdentifier.QueryResult.Video.VSync]);
	}

	if (OptionsMenuModuleIdentifier.QueryResult.Video.DepthOfField in videoOptions)
	{
		this.selectDepthOfFieldOption(videoOptions[OptionsMenuModuleIdentifier.QueryResult.Video.DepthOfField]);
	}
};