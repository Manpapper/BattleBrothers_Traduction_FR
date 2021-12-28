this.sallet_helmet <- this.inherit("scripts/items/helmets/helmet", {
	m = {},
	function create()
	{
		this.helmet.create();
		this.m.ID = "armor.head.sallet_helmet";
		this.m.Name = "Casque Sallet";
		this.m.Description = "Un casque sallet en métal avec un protège-cou allongé, un design peu commun dans ces contrées. Il est bien conçu pour offrir une protection maximale avec un poids minimal et sans altérer la vision.";
		this.m.ShowOnCharacter = true;
		this.m.IsDroppedAsLoot = true;
		this.m.HideHair = true;
		this.m.HideBeard = false;
		local variants = [
			163,
			163,
			163,
			163,
			163,
			163,
			163,
			164,
			165,
			166,
			167,
			185
		];
		this.m.Variant = variants[this.Math.rand(0, variants.len() - 1)];
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorChainmailImpact;
		this.m.InventorySound = this.Const.Sound.ArmorChainmailImpact;
		this.m.Value = 1200;
		this.m.Condition = 120;
		this.m.ConditionMax = 120;
		this.m.StaminaModifier = -5;
		this.m.Vision = 0;
	}

	function setPlainVariant()
	{
		this.setVariant(1);
	}

	function onPaint( _color )
	{
		switch(_color)
		{
		case this.Const.Items.Paint.None:
			this.m.Variant = 163;
			break;

		case this.Const.Items.Paint.Black:
			this.m.Variant = 164;
			break;

		case this.Const.Items.Paint.WhiteBlue:
			this.m.Variant = 167;
			break;

		case this.Const.Items.Paint.WhiteGreenYellow:
			this.m.Variant = 166;
			break;

		case this.Const.Items.Paint.OrangeRed:
			this.m.Variant = 165;
			break;

		case this.Const.Items.Paint.Red:
			this.m.Variant = 185;
			break;
		}

		this.updateVariant();
		this.updateAppearance();
	}

});

