this.blast_furnace_location <- this.inherit("scripts/entity/world/attached_location", {
	m = {
		LastFireTime = 0
	},
	function create()
	{
		this.attached_location.create();
		this.m.Name = "Haut Fourneau";
		this.m.ID = "attached_location.blast_furnace";
		this.m.Description = "Le haut fourneau produit les températures ardentes nécessaires à la fabrication des alliages métalliques les plus durables. Des armuriers habiles utiliseront ces alliages pour créer des armures solides dans la colonie la plus proche.";
		this.m.Sprite = "world_blast_furnace_01";
		this.m.SpriteDestroyed = "world_blast_furnace_01_ruins";
	}

	function getSounds( _all = true )
	{
		local r = [];

		if (this.World.getTime().IsDaytime)
		{
			r = [
				{
					File = "ambience/buildings/blacksmith_hot_water_00.wav",
					Volume = 1.0,
					Pitch = 1.0
				},
				{
					File = "ambience/buildings/blacksmith_hammering_00.wav",
					Volume = 1.0,
					Pitch = 1.0
				},
				{
					File = "ambience/buildings/blacksmith_hammering_01.wav",
					Volume = 1.0,
					Pitch = 1.0
				},
				{
					File = "ambience/buildings/blacksmith_hammering_02.wav",
					Volume = 1.0,
					Pitch = 1.0
				}
			];

			foreach( s in r )
			{
				s.Volume *= this.Const.Sound.Volume.Ambience / this.Const.Sound.Volume.AmbienceOutsideSettlement;
			}
		}

		return r;
	}

	function onUpdateDraftList( _list )
	{
		if (!this.isActive())
		{
			return;
		}

		_list.push("squire_background");
		_list.push("deserter_background");
		_list.push("disowned_noble_background");
	}

	function onUpdateShopList( _id, _list )
	{
		if (_id == "building.marketplace")
		{
			_list.push({
				R = 10,
				P = 1.0,
				S = "armor/leather_tunic"
			});
			_list.push({
				R = 10,
				P = 1.0,
				S = "armor/apron"
			});
			_list.push({
				R = 25,
				P = 1.0,
				S = "supplies/armor_parts_item"
			});
		}
		else if (_id == "building.specialized_trader")
		{
		}
		else if (_id == "building.weaponsmith")
		{
		}
		else if (_id == "building.armorsmith")
		{
			_list.push({
				R = 20,
				P = 1.0,
				S = "armor/leather_lamellar"
			});
			_list.push({
				R = 35,
				P = 1.0,
				S = "armor/mail_hauberk"
			});
			_list.push({
				R = 40,
				P = 1.0,
				S = "armor/reinforced_mail_hauberk"
			});
			_list.push({
				R = 45,
				P = 1.0,
				S = "armor/lamellar_harness"
			});
			_list.push({
				R = 20,
				P = 1.0,
				S = "helmets/padded_nasal_helmet"
			});
			_list.push({
				R = 25,
				P = 1.0,
				S = "helmets/padded_kettle_hat"
			});
			_list.push({
				R = 30,
				P = 1.0,
				S = "helmets/padded_flat_top_helmet"
			});
			_list.push({
				R = 35,
				P = 1.0,
				S = "helmets/closed_flat_top_helmet"
			});
			_list.push({
				R = 35,
				P = 1.0,
				S = "helmets/closed_flat_top_with_mail"
			});
			_list.push({
				R = 30,
				P = 1.0,
				S = "shields/kite_shield"
			});
			_list.push({
				R = 45,
				P = 1.0,
				S = "armor/scale_armor"
			});
			_list.push({
				R = 50,
				P = 1.0,
				S = "armor/heavy_lamellar_armor"
			});
			_list.push({
				R = 55,
				P = 1.0,
				S = "armor/coat_of_scales"
			});
			_list.push({
				R = 55,
				P = 1.0,
				S = "armor/coat_of_plates"
			});
			_list.push({
				R = 40,
				P = 1.0,
				S = "helmets/closed_flat_top_with_neckguard"
			});
			_list.push({
				R = 40,
				P = 1.0,
				S = "helmets/nasal_helmet_with_mail"
			});
			_list.push({
				R = 40,
				P = 1.0,
				S = "helmets/bascinet_with_mail"
			});
			_list.push({
				R = 40,
				P = 1.0,
				S = "helmets/kettle_hat_with_mail"
			});
			_list.push({
				R = 45,
				P = 1.0,
				S = "helmets/kettle_hat_with_closed_mail"
			});
			_list.push({
				R = 45,
				P = 1.0,
				S = "helmets/nasal_helmet_with_closed_mail"
			});
			_list.push({
				R = 45,
				P = 1.0,
				S = "helmets/flat_top_with_mail"
			});
			_list.push({
				R = 50,
				P = 1.0,
				S = "helmets/full_helm"
			});
			_list.push({
				R = 35,
				P = 1.0,
				S = "shields/heater_shield"
			});
		}
	}

	function onInit()
	{
		this.attached_location.onInit();
		this.registerThinker();
	}

	function onFinish()
	{
		this.attached_location.onFinish();
		this.unregisterThinker();
	}

	function onUpdate()
	{
		if (!this.m.IsActive)
		{
			return;
		}

		if (this.m.Settlement != null && this.m.Settlement.isDiscovered() && this.World.getTime().IsDaytime && this.Time.getRealTimeF() - this.m.LastFireTime >= 10.0)
		{
			this.m.LastFireTime = this.Time.getRealTimeF();
			local smoke = this.Const.World.CampSmokeParticles;

			for( local i = 0; i < smoke.len(); i = ++i )
			{
				this.World.spawnParticleEffect(smoke[i].Brushes, smoke[i].Delay, smoke[i].Quantity, smoke[i].LifeTime, smoke[i].SpawnRate, smoke[i].Stages, this.createVec(this.getPos().X + 10, this.getPos().Y + 15), -200 + this.Const.World.ZLevel.Particles);
			}
		}
	}

});

