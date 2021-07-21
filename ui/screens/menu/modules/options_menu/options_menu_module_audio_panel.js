/*
 *  @Project:		Battle Brothers
 *	@Company:		Overhype Studios
 *
 *	@Copyright:		(c) Overhype Studios | 2013 - 2020
 * 
 *  @Author:		Overhype Studios
 *  @Date:			12.04.2017 (refactored: 03.10.2017)
 *  @Description:	Options Menu Module - Audio Panel JS
 */
"use strict";


var OptionsMenuModuleAudioPanel = function(_dataSource)
{
	this.mDataSource = _dataSource;
 
	// container
	this.mContainer = null;
	
	// controls
	this.mVolumeOptions = {
		Master: {
			Control: null,
			OptionsKey: OptionsMenuModuleIdentifier.QueryResult.Audio.Master
		},
		Music: {
			Control: null,
			OptionsKey: OptionsMenuModuleIdentifier.QueryResult.Audio.Music
		},
		Effects: {
			Control: null,
			OptionsKey: OptionsMenuModuleIdentifier.QueryResult.Audio.Effects
		},
		Ambience: {
			Control: null,
			OptionsKey: OptionsMenuModuleIdentifier.QueryResult.Audio.Ambience
		}
	};

	// constants
	this.mVolumeMin = 0;
	this.mVolumeMax = 100;
	this.mVolumeStep = 10;
	this.mIsSystemChange = false;

    this.registerDatasourceListener();
};


OptionsMenuModuleAudioPanel.prototype.createDIV = function (_parentDiv)
{
	// create: character panel (init hidden)
	this.mContainer = $('<div class="audio-panel display-none"></div>');
    _parentDiv.append(this.mContainer);

	// create: columns
	var leftColumn = $('<div class="column"></div>');
	this.mContainer.append(leftColumn);
	var rightColumn = $('<div class="column"></div>');
	this.mContainer.append(rightColumn);

	// create: audio options
	var row = $('<div class="row"></div>');
	leftColumn.append(row);
	var displayTile = $('<div class="title title-font-big font-bold font-color-title">Volume</div>');
	row.append(displayTile);
	
	this.createVolumeControlDIV(this.mVolumeOptions.Master, 'Master', row);	
	this.createVolumeControlDIV(this.mVolumeOptions.Music, 'Music', row);
	this.createVolumeControlDIV(this.mVolumeOptions.Effects, 'Effects', row);
    this.createVolumeControlDIV(this.mVolumeOptions.Ambience, 'Ambience', row);

    var row = $('<div class="row"></div>');
    rightColumn.append(row);
    var displayTile = $('<div class="title title-font-big font-bold font-color-title">Advanced</div>');
    row.append(displayTile);

    var hwControl = $('<div class="control"/>');
    row.append(hwControl);
    this.mHWCheckbox = $('<input type="checkbox" id="cb-hw"/>');
    hwControl.append(this.mHWCheckbox);
    this.mHWLabel = $('<label class="text-font-normal font-color-subtitle" for="cb-hw">Hardware Sound</label>');
    hwControl.append(this.mHWLabel);
    this.mHWCheckbox.iCheck(
    {
        checkboxClass: 'icheckbox_flat-orange',
        radioClass: 'iradio_flat-orange',
        increaseArea: '30%'
    });

    this.setupEventHandler();
};

OptionsMenuModuleAudioPanel.prototype.destroyDIV = function ()
{
    // controls
    $.each(this.mVolumeOptions, function (_key, _value)
    {
        _value.Control.remove();
        _value.Control = null;
    });

    this.mContainer.empty();
    this.mContainer = null;
};


OptionsMenuModuleAudioPanel.prototype.setupEventHandler = function ()
{
    //this.removeEventHandler();

    this.mHWCheckbox.on('ifChecked ifUnchecked', null, this, function (_event)
    {
        var self = _event.data;
        self.mDataSource.updateAudioOption(OptionsMenuModuleIdentifier.QueryResult.Audio.HWSound, self.mHWCheckbox.prop('checked') === true);
    });
};


OptionsMenuModuleAudioPanel.prototype.createVolumeControlDIV = function (_definition, _label, _parentDiv)
{
    var self = this;

	var control = $('<div class="volume-control"></div>');
	_parentDiv.append(control);

	var label = $('<div class="volume-label text-font-normal font-color-subtitle">' + _label + '</div>');
	control.append(label);

	_definition.Control = $('<input class="volume-slider" type="range" min="0" max="100" step="1" />');
	control.append(_definition.Control);

	_definition.Control.on("change", function ()
	{
	    if (!self.mIsSystemChange)
	    {
	        var value = parseInt(_definition.Control.val());
	        self.mDataSource.updateAudioOption(_definition.OptionsKey, value);
	    }
	});
};


OptionsMenuModuleAudioPanel.prototype.bindTooltips = function ()
{
    this.mHWLabel.bindTooltip({ contentType: 'ui-element', elementId: TooltipIdentifier.MenuScreen.Options.HardwareSound });
};

OptionsMenuModuleAudioPanel.prototype.unbindTooltips = function ()
{
    this.mHWLabel.unbindTooltip();
};


OptionsMenuModuleAudioPanel.prototype.updateVolume = function(_data, _definition)
{
	if (_data === null || typeof(_data) !== 'number')
	{
		return;
	}

	self.mIsSystemChange = true;

	_definition.Control.val(_data);

	self.mIsSystemChange = false;
};


OptionsMenuModuleAudioPanel.prototype.registerDatasourceListener = function()
{
	this.mDataSource.addListener(OptionsMenuModuleDatasourceIdentifier.Options.Loaded, jQuery.proxy(this.onOptionsLoaded, this));
	this.mDataSource.addListener(OptionsMenuModuleDatasourceIdentifier.Options.Reseted, jQuery.proxy(this.onDefaultsLoaded, this));
};


OptionsMenuModuleAudioPanel.prototype.create = function(_parentDiv)
{
    this.createDIV(_parentDiv);
    this.bindTooltips();
};

OptionsMenuModuleAudioPanel.prototype.destroy = function()
{
    this.unbindTooltips();
    this.destroyDIV();
};


OptionsMenuModuleAudioPanel.prototype.register = function (_parentDiv)
{
    console.log('OptionsMenuModuleAudioPanel::REGISTER');

    if (this.mContainer !== null)
    {
        console.error('ERROR: Failed to register Audio Panel Module. Reason: Audio Panel Module is already initialized.');
        return;
    }

    if (_parentDiv !== null && typeof(_parentDiv) == 'object')
    {
        this.create(_parentDiv);
    }
};

OptionsMenuModuleAudioPanel.prototype.unregister = function ()
{
    console.log('OptionsMenuModuleVideoPanel::UNREGISTER');

    if (this.mContainer === null)
    {
        console.error('ERROR: Failed to unregister Audio Panel Module. Reason: Audio Panel Module is not initialized.');
        return;
    }

    this.destroy();
};

OptionsMenuModuleAudioPanel.prototype.isRegistered = function ()
{
	if (this.mContainer !== null)
	{
		return this.mContainer.parent().length !== 0;
	}

	return false;
};


OptionsMenuModuleAudioPanel.prototype.show = function ()
{
	this.mContainer.removeClass('display-none').addClass('display-block');
};

OptionsMenuModuleAudioPanel.prototype.hide = function ()
{
	this.mContainer.removeClass('display-block').addClass('display-none');
};


OptionsMenuModuleAudioPanel.prototype.onOptionsLoaded = function (_dataSource, _data)
{
	// get audio options
	var audioOptions = _dataSource.getAudioOptions();
	if (OptionsMenuModuleIdentifier.QueryResult.Audio.Master in audioOptions)
	{
		this.updateVolume(audioOptions[OptionsMenuModuleIdentifier.QueryResult.Audio.Master], this.mVolumeOptions.Master);
	}

	if (OptionsMenuModuleIdentifier.QueryResult.Audio.Music in audioOptions)
	{
		this.updateVolume(audioOptions[OptionsMenuModuleIdentifier.QueryResult.Audio.Music], this.mVolumeOptions.Music);
	}

	if (OptionsMenuModuleIdentifier.QueryResult.Audio.Effects in audioOptions)
	{
		this.updateVolume(audioOptions[OptionsMenuModuleIdentifier.QueryResult.Audio.Effects], this.mVolumeOptions.Effects);
	}

	if (OptionsMenuModuleIdentifier.QueryResult.Audio.Ambience in audioOptions)
	{
		this.updateVolume(audioOptions[OptionsMenuModuleIdentifier.QueryResult.Audio.Ambience], this.mVolumeOptions.Ambience);
    }

    if (OptionsMenuModuleIdentifier.QueryResult.Audio.HWSound in audioOptions)
    {
        this.mHWCheckbox.iCheck(audioOptions[OptionsMenuModuleIdentifier.QueryResult.Audio.HWSound] === true ? 'check' : 'uncheck');
    }
};

OptionsMenuModuleAudioPanel.prototype.onDefaultsLoaded = function (_dataSource, _data)
{
	// get audio options
	var audioOptions = _dataSource.getAudioOptions();
	if (OptionsMenuModuleIdentifier.QueryResult.Audio.Master in audioOptions)
	{
		this.updateVolume(audioOptions[OptionsMenuModuleIdentifier.QueryResult.Audio.Master], this.mVolumeOptions.Master);
	}

	if (OptionsMenuModuleIdentifier.QueryResult.Audio.Music in audioOptions)
	{
		this.updateVolume(audioOptions[OptionsMenuModuleIdentifier.QueryResult.Audio.Music], this.mVolumeOptions.Music);
	}

	if (OptionsMenuModuleIdentifier.QueryResult.Audio.Effects in audioOptions)
	{
		this.updateVolume(audioOptions[OptionsMenuModuleIdentifier.QueryResult.Audio.Effects], this.mVolumeOptions.Effects);
	}

	if (OptionsMenuModuleIdentifier.QueryResult.Audio.Ambience in audioOptions)
	{
		this.updateVolume(audioOptions[OptionsMenuModuleIdentifier.QueryResult.Audio.Ambience], this.mVolumeOptions.Ambience);
    }

    if (OptionsMenuModuleIdentifier.QueryResult.Audio.HWSound in audioOptions)
    {
        this.mHWCheckbox.iCheck(audioOptions[OptionsMenuModuleIdentifier.QueryResult.Audio.HWSound] === true ? 'check' : 'uncheck');
    }
};