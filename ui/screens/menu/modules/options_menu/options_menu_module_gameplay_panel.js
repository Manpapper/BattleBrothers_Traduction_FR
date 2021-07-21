/*
 *  @Project:		Battle Brothers
 *	@Company:		Overhype Studios
 *
 *	@Copyright:		(c) Overhype Studios | 2013 - 2020
 * 
 *  @Author:		Overhype Studios
 *  @Date:			12.04.2017 (refactored: 03.10.2017)
 *  @Description:	Options Menu Module - Gameplay Panel JS
 */
"use strict";


var OptionsMenuModuleGameplayPanel = function(_dataSource)
{
	this.mDataSource = _dataSource;
 
	// container
	this.mContainer = null;
	
	// controls
	this.mCameraFollowCheckbox			= null;
	this.mCameraAdjustLevelCheckbox		= null;
	this.mStatsOverlaysCheckbox			= null;
	this.mOrientationOverlaysCheckbox	= null;
	this.mMovementPlayerCheckbox		= null;
	this.mMovementAICheckbox			= null;
	this.mAutoLootCheckbox				= null;
	this.mAlwaysHideTreesCheckbox		= null;
	this.mAutoEndTurnCheckbox			= null;
	this.mRestoreEquipmentCheckbox		= null;
    this.mAutoPauseAfterCityCheckbox    = null;

	this.mCameraFollowLabel				= null;
	this.mCameraAdjustLevelLabel		= null;
	this.mStatsOverlaysLabel			= null;
	this.mOrientationOverlaysLabel		= null;
	this.mMovementPlayerLabel			= null;
	this.mMovementAILabel				= null;
	this.mAutoLootLabel					= null;
	this.mAlwaysHideTreesLabel			= null;
	this.mAutoEndTurnLabel				= null;
    this.mRestoreEquipmentLabel         = null;
    this.mAutoPauseAfterCityLabel       = null;

    this.registerDatasourceListener();
};


OptionsMenuModuleGameplayPanel.prototype.createDIV = function (_parentDiv)
{
	// create: character panel (init hidden!)
	this.mContainer = $('<div class="gameplay-panel display-none"></div>');
    _parentDiv.append(this.mContainer);

	// create: columns
	var leftColumn = $('<div class="column"></div>');
	this.mContainer.append(leftColumn);
	var rightColumn = $('<div class="column"></div>');
	this.mContainer.append(rightColumn);

	// create: camera options
	row = $('<div class="row"></div>');
	leftColumn.append(row);
	var displayTile = $('<div class="title title-font-big font-color-title">Camera</div>');
	row.append(displayTile);

	var control = $('<div class="control"></div>');
	row.append(control);
	this.mCameraFollowCheckbox = $('<input type="checkbox" id="cb-camera-follow" name="camera-follow" />');
	control.append(this.mCameraFollowCheckbox);
	var cameraFollowCheckboxLabel = $('<label class="text-font-normal font-color-subtitle" for="cb-camera-follow">Always Focus AI Movement</label>');
	this.mCameraFollowLabel = cameraFollowCheckboxLabel;
	control.append(cameraFollowCheckboxLabel);
	this.mCameraFollowCheckbox.iCheck({
		checkboxClass: 'icheckbox_flat-orange',
		radioClass: 'iradio_flat-orange',
		increaseArea: '30%'
    });

	control = $('<div class="control"></div>');
	row.append(control);
	this.mCameraAdjustLevelCheckbox = $('<input type="checkbox" id="cb-camera-adjust" name="camera-adjust-level" />');
	control.append(this.mCameraAdjustLevelCheckbox);
	var cameraAdjustLevelCheckboxLabel = $('<label class="text-font-normal font-color-subtitle" for="cb-camera-adjust">Auto-Adjust Height Level</label>');
	this.mCameraAdjustLevelLabel = cameraAdjustLevelCheckboxLabel;
	control.append(cameraAdjustLevelCheckboxLabel);
	this.mCameraAdjustLevelCheckbox.iCheck({
		checkboxClass: 'icheckbox_flat-orange',
		radioClass: 'iradio_flat-orange',
		increaseArea: '30%'
    });

	control = $('<div class="control"></div>');
	row.append(control);
	this.mAlwaysHideTreesCheckbox = $('<input type="checkbox" id="cb-always-hide-trees" name="always-hide-trees" />');
	control.append(this.mAlwaysHideTreesCheckbox);
	var alwaysHideTreesCheckboxLabel = $('<label class="text-font-normal font-color-subtitle" for="cb-always-hide-trees">Always Hide Trees</label>');
	this.mAlwaysHideTreesLabel = alwaysHideTreesCheckboxLabel;
	control.append(alwaysHideTreesCheckboxLabel);
	this.mAlwaysHideTreesCheckbox.iCheck({
		checkboxClass: 'icheckbox_flat-orange',
		radioClass: 'iradio_flat-orange',
		increaseArea: '30%'
    });

	// create: overlays options
	var row = $('<div class="row"></div>');
	rightColumn.append(row);
	displayTile = $('<div class="title title-font-big font-color-title">Overlays</div>');
	row.append(displayTile);
	
	control = $('<div class="control"></div>');
	row.append(control);
	this.mStatsOverlaysCheckbox = $('<input type="checkbox" id="cb-stats-overlays" name="stats-overlays" />');
	control.append(this.mStatsOverlaysCheckbox);
	var statsOverlaysCheckboxLabel = $('<label class="text-font-normal font-color-subtitle" for="cb-stats-overlays">Always Show Hitpoint Bars</label>');
	this.mStatsOverlaysLabel = statsOverlaysCheckboxLabel;
	control.append(statsOverlaysCheckboxLabel);
	this.mStatsOverlaysCheckbox.iCheck({
		checkboxClass: 'icheckbox_flat-orange',
		radioClass: 'iradio_flat-orange',
		increaseArea: '30%'
    });

	control = $('<div class="control"></div>');
	row.append(control);
	this.mOrientationOverlaysCheckbox = $('<input type="checkbox" id="cb-orientation-overlays" name="orientation-overlays" />');
	control.append(this.mOrientationOverlaysCheckbox);
	var orientationOverlaysCheckboxLabel = $('<label class="text-font-normal font-color-subtitle" for="cb-orientation-overlays">Show Orientation Icons</label>');
	this.mOrientationOverlaysLabel = orientationOverlaysCheckboxLabel;
	control.append(orientationOverlaysCheckboxLabel);
	this.mOrientationOverlaysCheckbox.iCheck({
		checkboxClass: 'icheckbox_flat-orange',
		radioClass: 'iradio_flat-orange',
		increaseArea: '30%'
    });

	// create: other options
	row = $('<div class="row"></div>');
	leftColumn.append(row);
	var displayTile = $('<div class="title title-font-big font-color-title">Flow</div>');
	row.append(displayTile);

	var control = $('<div class="control"></div>');
	row.append(control);
	this.mMovementPlayerCheckbox = $('<input type="checkbox" id="cb-movement-player" name="movement-player" />');
	control.append(this.mMovementPlayerCheckbox);
	var movementPlayerCheckboxLabel = $('<label class="text-font-normal font-color-subtitle" for="cb-movement-player">Faster Player Movement</label>');
	this.mMovementPlayerLabel = movementPlayerCheckboxLabel;
	control.append(movementPlayerCheckboxLabel);
	this.mMovementPlayerCheckbox.iCheck({
		checkboxClass: 'icheckbox_flat-orange',
		radioClass: 'iradio_flat-orange',
		increaseArea: '30%'
    });

	control = $('<div class="control"></div>');
	row.append(control);
	this.mMovementAICheckbox = $('<input type="checkbox" id="cb-movement-ai" name="movement-ai" />');
	control.append(this.mMovementAICheckbox);
	var movementAICheckboxLabel = $('<label class="text-font-normal font-color-subtitle" for="cb-movement-ai">Faster AI Movement</label>');
	this.mMovementAILabel = movementAICheckboxLabel;
	control.append(movementAICheckboxLabel);
	this.mMovementAICheckbox.iCheck({
		checkboxClass: 'icheckbox_flat-orange',
		radioClass: 'iradio_flat-orange',
		increaseArea: '30%'
    });

	control = $('<div class="control"></div>');
	row.append(control);
	this.mAutoEndTurnCheckbox = $('<input type="checkbox" id="cb-auto-end-turn" name="auto-end-turn" />');
	control.append(this.mAutoEndTurnCheckbox);
	var AutoEndTurnCheckboxLabel = $('<label class="text-font-normal font-color-subtitle" for="cb-auto-end-turn">Auto-End Turns</label>');
	this.mAutoEndTurnLabel = AutoEndTurnCheckboxLabel;
	control.append(AutoEndTurnCheckboxLabel);
	this.mAutoEndTurnCheckbox.iCheck({
		checkboxClass: 'icheckbox_flat-orange',
		radioClass: 'iradio_flat-orange',
		increaseArea: '30%'
    });

	control = $('<div class="control"></div>');
	row.append(control);
	this.mAutoLootCheckbox = $('<input type="checkbox" id="cb-auto-loot" name="auto-loot" />');
	control.append(this.mAutoLootCheckbox);
	var autoLootCheckboxLabel = $('<label class="text-font-normal font-color-subtitle" for="cb-auto-loot">Auto-Loot</label>');
	this.mAutoLootLabel = autoLootCheckboxLabel;
	control.append(autoLootCheckboxLabel);
	this.mAutoLootCheckbox.iCheck({
		checkboxClass: 'icheckbox_flat-orange',
		radioClass: 'iradio_flat-orange',
		increaseArea: '30%'
	});

	control = $('<div class="control"></div>');
	row.append(control);
	this.mRestoreEquipmentCheckbox = $('<input type="checkbox" id="cb-restore-equipment" name="restore-equipment" />');
	control.append(this.mRestoreEquipmentCheckbox);
	var restoreEquipmentLabel = $('<label class="text-font-normal font-color-subtitle" for="cb-restore-equipment">Reset Equipment After Battle</label>');
	this.mRestoreEquipmentLabel = restoreEquipmentLabel;
	control.append(restoreEquipmentLabel);
	this.mRestoreEquipmentCheckbox.iCheck({
		checkboxClass: 'icheckbox_flat-orange',
		radioClass: 'iradio_flat-orange',
		increaseArea: '30%'
    });

    control = $('<div class="control"></div>');
    row.append(control);
    this.mAutoPauseAfterCityCheckbox = $('<input type="checkbox" id="cb-auto-pause-after-city" name="auto-pause-after-city" />');
    control.append(this.mAutoPauseAfterCityCheckbox);
    var autoPauseAfterCityLabel = $('<label class="text-font-normal font-color-subtitle" for="cb-auto-pause-after-city">Auto-Pause After Leaving City</label>');
    this.mAutoPauseAfterCityLabel = autoPauseAfterCityLabel;
    control.append(autoPauseAfterCityLabel);
    this.mAutoPauseAfterCityCheckbox.iCheck({
        checkboxClass: 'icheckbox_flat-orange',
        radioClass: 'iradio_flat-orange',
        increaseArea: '30%'
    });

    this.setupEventHandler();
};

OptionsMenuModuleGameplayPanel.prototype.destroyDIV = function ()
{
    // controls
    this.mCameraFollowCheckbox.remove();
    this.mCameraFollowCheckbox = null;
	this.mCameraAdjustLevelCheckbox.remove();
    this.mCameraAdjustLevelCheckbox = null;
	this.mAlwaysHideTreesCheckbox.remove();
    this.mAlwaysHideTreesCheckbox = null;
    this.mStatsOverlaysCheckbox.remove();
    this.mStatsOverlaysCheckbox = null;
    this.mOrientationOverlaysCheckbox.remove();
    this.mOrientationOverlaysCheckbox = null;
	this.mMovementPlayerCheckbox.remove();
    this.mMovementPlayerCheckbox = null;
	this.mMovementAICheckbox.remove();
    this.mMovementAICheckbox = null;
	this.mAutoEndTurnCheckbox.remove();
    this.mAutoEndTurnCheckbox = null;
	this.mAutoLootCheckbox.remove();
    this.mAutoLootCheckbox = null;
    this.mRestoreEquipmentCheckbox.remove();
    this.mRestoreEquipmentCheckbox = null;

    this.mContainer.empty();
    this.mContainer = null;
};


OptionsMenuModuleGameplayPanel.prototype.setupEventHandler = function ()
{
    //this.removeEventHandler();

	this.mCameraFollowCheckbox.on('ifChecked ifUnchecked', null, this, function (_event)
	{
        var self = _event.data;
        self.mDataSource.updateGameplayOption(OptionsMenuModuleIdentifier.QueryResult.Gameplay.CameraFollowMode, self.mCameraFollowCheckbox.prop('checked') === true);
    });

    this.mCameraAdjustLevelCheckbox.on('ifChecked ifUnchecked', null, this, function (_event)
    {
        var self = _event.data;
        self.mDataSource.updateGameplayOption(OptionsMenuModuleIdentifier.QueryResult.Gameplay.CameraAdjustLevel, self.mCameraAdjustLevelCheckbox.prop('checked') === true);
    });

	this.mAlwaysHideTreesCheckbox.on('ifChecked ifUnchecked', null, this, function (_event)
	{
        var self = _event.data;
        self.mDataSource.updateGameplayOption(OptionsMenuModuleIdentifier.QueryResult.Gameplay.AlwaysHideTrees, self.mAlwaysHideTreesCheckbox.prop('checked') === true);
    });

	this.mStatsOverlaysCheckbox.on('ifChecked ifUnchecked', null, this, function (_event)
	{
        var self = _event.data;
        self.mDataSource.updateGameplayOption(OptionsMenuModuleIdentifier.QueryResult.Gameplay.StatsOverlays, self.mStatsOverlaysCheckbox.prop('checked') === true);
    });

    this.mOrientationOverlaysCheckbox.on('ifChecked ifUnchecked', null, this, function (_event)
    {
        var self = _event.data;
        self.mDataSource.updateGameplayOption(OptionsMenuModuleIdentifier.QueryResult.Gameplay.OrientationOverlays, self.mOrientationOverlaysCheckbox.prop('checked') === true);
    });

    this.mMovementPlayerCheckbox.on('ifChecked ifUnchecked', null, this, function (_event)
    {
        var self = _event.data;
        self.mDataSource.updateGameplayOption(OptionsMenuModuleIdentifier.QueryResult.Gameplay.MovementPlayer, self.mMovementPlayerCheckbox.prop('checked') === true);
    });

	this.mMovementAICheckbox.on('ifChecked ifUnchecked', null, this, function (_event)
	{
        var self = _event.data;
        self.mDataSource.updateGameplayOption(OptionsMenuModuleIdentifier.QueryResult.Gameplay.MovementAI, self.mMovementAICheckbox.prop('checked') === true);
    });

	this.mAutoEndTurnCheckbox.on('ifChecked ifUnchecked', null, this, function (_event)
	{
		var self = _event.data;
		self.mDataSource.updateGameplayOption(OptionsMenuModuleIdentifier.QueryResult.Gameplay.AutoEndTurn, self.mAutoEndTurnCheckbox.prop('checked') === true);
    });

	this.mAutoLootCheckbox.on('ifChecked ifUnchecked', null, this, function (_event)
	{
        var self = _event.data;
        self.mDataSource.updateGameplayOption(OptionsMenuModuleIdentifier.QueryResult.Gameplay.AutoLoot, self.mAutoLootCheckbox.prop('checked') === true);
	});

	this.mRestoreEquipmentCheckbox.on('ifChecked ifUnchecked', null, this, function (_event)
	{
		var self = _event.data;
		self.mDataSource.updateGameplayOption(OptionsMenuModuleIdentifier.QueryResult.Gameplay.RestoreEquipment, self.mRestoreEquipmentCheckbox.prop('checked') === true);
    });

    this.mAutoPauseAfterCityCheckbox.on('ifChecked ifUnchecked', null, this, function (_event)
    {
        var self = _event.data;
        self.mDataSource.updateGameplayOption(OptionsMenuModuleIdentifier.QueryResult.Gameplay.AutoPauseAfterCity, self.mAutoPauseAfterCityCheckbox.prop('checked') === true);
    });
};

/*
OptionsMenuModuleGameplayPanel.prototype.removeEventHandler = function ()
{
    this.mCameraFollowCheckbox.off('ifChecked ifUnchecked');
    this.mStatsOverlaysCheckbox.off('ifChecked ifUnchecked');
    this.mOrientationOverlaysCheckbox.off('ifChecked ifUnchecked');
};
*/


OptionsMenuModuleGameplayPanel.prototype.bindTooltips = function ()
{
	this.mCameraFollowLabel.bindTooltip({ contentType: 'ui-element', elementId: TooltipIdentifier.MenuScreen.Options.CameraFollow });
	this.mCameraAdjustLevelLabel.bindTooltip({ contentType: 'ui-element', elementId: TooltipIdentifier.MenuScreen.Options.CameraAdjust });
	this.mStatsOverlaysLabel.bindTooltip({ contentType: 'ui-element', elementId: TooltipIdentifier.MenuScreen.Options.StatsOverlays });
	this.mOrientationOverlaysLabel.bindTooltip({ contentType: 'ui-element', elementId: TooltipIdentifier.MenuScreen.Options.OrientationOverlays });
	this.mMovementPlayerLabel.bindTooltip({ contentType: 'ui-element', elementId: TooltipIdentifier.MenuScreen.Options.MovementPlayer });
	this.mMovementAILabel.bindTooltip({ contentType: 'ui-element', elementId: TooltipIdentifier.MenuScreen.Options.MovementAI });
	this.mAutoLootLabel.bindTooltip({ contentType: 'ui-element', elementId: TooltipIdentifier.MenuScreen.Options.AutoLoot });
	this.mAlwaysHideTreesLabel.bindTooltip({ contentType: 'ui-element', elementId: TooltipIdentifier.MenuScreen.Options.AlwaysHideTrees });
	this.mAutoEndTurnLabel.bindTooltip({ contentType: 'ui-element', elementId: TooltipIdentifier.MenuScreen.Options.AutoEndTurns });
    this.mRestoreEquipmentLabel.bindTooltip({ contentType: 'ui-element', elementId: TooltipIdentifier.MenuScreen.Options.RestoreEquipment });
    this.mAutoPauseAfterCityLabel.bindTooltip({ contentType: 'ui-element', elementId: TooltipIdentifier.MenuScreen.Options.AutoPauseAfterCity });
};

OptionsMenuModuleGameplayPanel.prototype.unbindTooltips = function ()
{
	this.mCameraFollowLabel.unbindTooltip();
	this.mCameraAdjustLevelLabel.unbindTooltip();
	this.mStatsOverlaysLabel.unbindTooltip();
	this.mOrientationOverlaysLabel.unbindTooltip();
	this.mMovementPlayerLabel.unbindTooltip();
	this.mMovementAILabel.unbindTooltip();
	this.mAutoLootLabel.unbindTooltip();
	this.mAlwaysHideTreesLabel.unbindTooltip();
	this.mAutoEndTurnLabel.unbindTooltip();
    this.mRestoreEquipmentLabel.unbindTooltip();
    this.mAutoPauseAfterCityLabel.unbindTooltip();
};


OptionsMenuModuleGameplayPanel.prototype.selectCheckboxOption = function(_checkbox, _data)
{
	if (_data === null || typeof(_data) !== 'boolean')
	{
		return;
	}

	_checkbox.iCheck(_data === true ? 'check' : 'uncheck');
};


OptionsMenuModuleGameplayPanel.prototype.registerDatasourceListener = function()
{
	this.mDataSource.addListener(OptionsMenuModuleDatasourceIdentifier.Options.Loaded, jQuery.proxy(this.onOptionsLoaded, this));
	this.mDataSource.addListener(OptionsMenuModuleDatasourceIdentifier.Options.Reseted, jQuery.proxy(this.onDefaultsLoaded, this));
};


OptionsMenuModuleGameplayPanel.prototype.create = function(_parentDiv)
{
    this.createDIV(_parentDiv);
    this.bindTooltips();
};

OptionsMenuModuleGameplayPanel.prototype.destroy = function()
{
    this.unbindTooltips();
    this.destroyDIV();
};


OptionsMenuModuleGameplayPanel.prototype.register = function (_parentDiv)
{
    console.log('OptionsMenuModuleGameplayPanel::REGISTER');

    if (this.mContainer !== null)
    {
        console.error('ERROR: Failed to register Gameplay Panel Module. Reason: Gameplay Panel Module is already initialized.');
        return;
    }

    if (_parentDiv !== null && typeof(_parentDiv) == 'object')
    {
        this.create(_parentDiv);
    }
};

OptionsMenuModuleGameplayPanel.prototype.unregister = function ()
{
    console.log('OptionsMenuModuleGameplayPanel::UNREGISTER');

    if (this.mContainer === null)
    {
        console.error('ERROR: Failed to unregister Gameplay Panel Module. Reason: Gameplay Panel Module is not initialized.');
        return;
    }

    this.destroy();
};

OptionsMenuModuleGameplayPanel.prototype.isRegistered = function ()
{
	if (this.mContainer !== null)
	{
		return this.mContainer.parent().length !== 0;
	}

	return false;
};


OptionsMenuModuleGameplayPanel.prototype.show = function ()
{
	this.mContainer.removeClass('display-none').addClass('display-block');
};

OptionsMenuModuleGameplayPanel.prototype.hide = function ()
{
	this.mContainer.removeClass('display-block').addClass('display-none');
};


OptionsMenuModuleGameplayPanel.prototype.onOptionsLoaded = function (_dataSource, _data)
{
	// get controls options
	var gameplayOptions = _dataSource.getGameplayOptions();
	
	if (OptionsMenuModuleIdentifier.QueryResult.Gameplay.CameraFollowMode in gameplayOptions)
	{
		this.selectCheckboxOption(this.mCameraFollowCheckbox, gameplayOptions[OptionsMenuModuleIdentifier.QueryResult.Gameplay.CameraFollowMode]);
	}

	if (OptionsMenuModuleIdentifier.QueryResult.Gameplay.CameraAdjustLevel in gameplayOptions)
	{
		this.selectCheckboxOption(this.mCameraAdjustLevelCheckbox, gameplayOptions[OptionsMenuModuleIdentifier.QueryResult.Gameplay.CameraAdjustLevel]);
	}

	if (OptionsMenuModuleIdentifier.QueryResult.Gameplay.AlwaysHideTrees in gameplayOptions)
	{
		this.selectCheckboxOption(this.mAlwaysHideTreesCheckbox, gameplayOptions[OptionsMenuModuleIdentifier.QueryResult.Gameplay.AlwaysHideTrees]);
	}

	if (OptionsMenuModuleIdentifier.QueryResult.Gameplay.StatsOverlays in gameplayOptions)
	{
		this.selectCheckboxOption(this.mStatsOverlaysCheckbox, gameplayOptions[OptionsMenuModuleIdentifier.QueryResult.Gameplay.StatsOverlays]);
	}

	if (OptionsMenuModuleIdentifier.QueryResult.Gameplay.OrientationOverlays in gameplayOptions)
	{
		this.selectCheckboxOption(this.mOrientationOverlaysCheckbox, gameplayOptions[OptionsMenuModuleIdentifier.QueryResult.Gameplay.OrientationOverlays]);
	}

	if (OptionsMenuModuleIdentifier.QueryResult.Gameplay.MovementPlayer in gameplayOptions)
	{
		this.selectCheckboxOption(this.mMovementPlayerCheckbox, gameplayOptions[OptionsMenuModuleIdentifier.QueryResult.Gameplay.MovementPlayer]);
	}

	if (OptionsMenuModuleIdentifier.QueryResult.Gameplay.MovementAI in gameplayOptions)
	{
		this.selectCheckboxOption(this.mMovementAICheckbox, gameplayOptions[OptionsMenuModuleIdentifier.QueryResult.Gameplay.MovementAI]);
	}

	if (OptionsMenuModuleIdentifier.QueryResult.Gameplay.AutoEndTurn in gameplayOptions)
	{
		this.selectCheckboxOption(this.mAutoEndTurnCheckbox, gameplayOptions[OptionsMenuModuleIdentifier.QueryResult.Gameplay.AutoEndTurn]);
	}

	if (OptionsMenuModuleIdentifier.QueryResult.Gameplay.AutoLoot in gameplayOptions)
	{
		this.selectCheckboxOption(this.mAutoLootCheckbox, gameplayOptions[OptionsMenuModuleIdentifier.QueryResult.Gameplay.AutoLoot]);
	}

	if (OptionsMenuModuleIdentifier.QueryResult.Gameplay.RestoreEquipment in gameplayOptions)
	{
		this.selectCheckboxOption(this.mRestoreEquipmentCheckbox, gameplayOptions[OptionsMenuModuleIdentifier.QueryResult.Gameplay.RestoreEquipment]);
    }

    if (OptionsMenuModuleIdentifier.QueryResult.Gameplay.AutoPauseAfterCity in gameplayOptions)
    {
        this.selectCheckboxOption(this.mAutoPauseAfterCityCheckbox, gameplayOptions[OptionsMenuModuleIdentifier.QueryResult.Gameplay.AutoPauseAfterCity]);
    }
};

OptionsMenuModuleGameplayPanel.prototype.onDefaultsLoaded = function (_dataSource, _data)
{
	this.onOptionsLoaded(_dataSource, _data);
};