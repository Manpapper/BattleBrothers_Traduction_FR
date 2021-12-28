this.fangshire <- this.inherit("scripts/items/helmets/helmet", {
	m = {},
	function create()
	{
		this.helmet.create();
		this.m.ID = "armor.head.fangshire";
		this.m.Name = "Le Fangshire";
		this.m.Description = "Le Fangshire est un crâne de tigre du nord qui se niche profondément et sombrement derrière deux crocs féroces. Porté à l\'origine par Bjarund l\'Homme-bête, un féroce pilleur du Nord, il a semé la peur dans le coeur de ses ennemis alors qu\'il effectuait des raids sanglants et incendiait de nombreux villages le long de la côte. Lorsque Bjarund a finalement été tué, Fangshire a été pris comme trophée et est allé plus au sud. Les rumeurs proclament que les yeux de son porteur brillent d\'un jaune aiguisé, leur permettant de voir à travers la nuit même.";
		this.m.ShowOnCharacter = true;
		this.m.IsDroppedAsLoot = true;
		this.m.HideHair = true;
		this.m.HideBeard = false;
		this.m.IsIndestructible = true;
		this.m.Variant = 24;
		this.updateVariant();
		this.m.ImpactSound = [
			"sounds/enemies/skeleton_hurt_03.wav"
		];
		this.m.Value = 300;
		this.m.Condition = 60;
		this.m.ConditionMax = 60;
		this.m.StaminaModifier = -5;
		this.m.ItemType = this.m.ItemType | this.Const.Items.ItemType.Legendary;
	}

	function getTooltip()
	{
		local result = this.helmet.getTooltip();
		result.push({
			id = 6,
			type = "text",
			icon = "ui/icons/vision.png",
			text = "Permet au porteur de voir la nuit et annule les pénalités dues à la nuit."
		});
		return result;
	}

	function onUpdateProperties( _properties )
	{
		this.helmet.onUpdateProperties(_properties);
		_properties.IsAffectedByNight = false;
	}

});

