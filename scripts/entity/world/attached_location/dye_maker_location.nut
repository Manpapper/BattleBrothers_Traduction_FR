this.dye_maker_location <- this.inherit("scripts/entity/world/attached_location", {
	m = {},
	function create()
	{
		this.attached_location.create();
		this.m.Name = "Fabricant de Teintures";
		this.m.ID = "attached_location.dye_maker";
		this.m.Description = "Ce teinturier crée des matrices précieuses à partir de toutes sortes d\'ingrédients. Les recettes de ces produits coûteux sont des secrets bien gardés.";
		this.m.Sprite = "world_dye_maker_01";
		this.m.SpriteDestroyed = "world_dye_maker_01_ruins";
	}

	function onUpdateProduce( _list )
	{
		_list.push("trade/dies_item");
	}

	function onUpdateDraftList( _list )
	{
		if (!this.isActive())
		{
			return;
		}

		_list.push("apprentice_background");
		_list.push("caravan_hand_background");
		_list.push("tailor_background");
	}

	function onUpdateShopList( _id, _list )
	{
		if (_id == "building.marketplace")
		{
			_list.push({
				R = 0,
				P = 1.0,
				S = "trade/dies_item"
			});

			if (this.Const.DLC.Unhold)
			{
				_list.push({
					R = 30,
					P = 1.0,
					S = "misc/paint_set_item"
				});
				_list.push({
					R = 50,
					P = 1.0,
					S = "misc/paint_black_item"
				});
				_list.push({
					R = 50,
					P = 1.0,
					S = "misc/paint_red_item"
				});
				_list.push({
					R = 50,
					P = 1.0,
					S = "misc/paint_orange_red_item"
				});
				_list.push({
					R = 50,
					P = 1.0,
					S = "misc/paint_white_blue_item"
				});
				_list.push({
					R = 50,
					P = 1.0,
					S = "misc/paint_white_green_yellow_item"
				});
			}
		}
		else if (_id == "building.specialized_trader")
		{
		}
	}

	function onInit()
	{
		this.attached_location.onInit();
		this.getSprite("body").Scale = 0.9;
	}

});

