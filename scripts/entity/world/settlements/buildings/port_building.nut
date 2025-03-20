this.port_building <- this.inherit("scripts/entity/world/settlements/buildings/building", {
	m = {},
	function isHidden()
	{
		return !this.m.Settlement.isCoastal();
	}

	function create()
	{
		this.building.create();
		this.m.ID = "building.port";
		this.m.Name = "Port";
		this.m.UIImage = "ui/settlements/building_09";
		this.m.UIImageNight = "ui/settlements/building_09_night";
		this.m.Tooltip = "world-town-screen.main-dialog-module.Port";
		this.m.TooltipIcon = "ui/icons/buildings/harbor.png";
		this.m.Description = "Un port qui sert à la fois aux navires de commerce étrangers et aux pêcheurs locaux";
		this.m.IsClosedAtNight = false;
		this.m.Sounds = [
			{
				File = "ambience/buildings/docks_rope_00.wav",
				Volume = 1.0,
				Pitch = 1.0
			},
			{
				File = "ambience/buildings/docks_rope_01.wav",
				Volume = 1.0,
				Pitch = 1.0
			},
			{
				File = "ambience/buildings/docks_bell_00.wav",
				Volume = 1.0,
				Pitch = 1.0
			},
			{
				File = "ambience/buildings/docks_bell_01.wav",
				Volume = 1.0,
				Pitch = 1.0
			},
			{
				File = "ambience/buildings/docks_bell_02.wav",
				Volume = 1.0,
				Pitch = 1.0
			},
			{
				File = "ambience/buildings/docks_flapping_sail_00.wav",
				Volume = 1.0,
				Pitch = 1.0
			},
			{
				File = "ambience/buildings/docks_flapping_sail_01.wav",
				Volume = 1.0,
				Pitch = 1.0
			},
			{
				File = "ambience/buildings/docks_ship_creaking_01.wav",
				Volume = 1.0,
				Pitch = 1.0
			},
			{
				File = "ambience/buildings/docks_ship_creaking_02.wav",
				Volume = 1.0,
				Pitch = 1.0
			},
			{
				File = "ambience/buildings/docks_ship_creaking_03.wav",
				Volume = 1.0,
				Pitch = 1.0
			},
			{
				File = "ambience/buildings/docks_ship_creaking_04.wav",
				Volume = 1.0,
				Pitch = 1.0
			},
			{
				File = "ambience/buildings/docks_working_00.wav",
				Volume = 1.0,
				Pitch = 1.0
			},
			{
				File = "ambience/buildings/docks_working_01.wav",
				Volume = 1.0,
				Pitch = 1.0
			},
			{
				File = "ambience/buildings/docks_working_02.wav",
				Volume = 1.0,
				Pitch = 1.0
			},
			{
				File = "ambience/buildings/docks_working_03.wav",
				Volume = 1.0,
				Pitch = 1.0
			},
			{
				File = "ambience/buildings/docks_working_04.wav",
				Volume = 1.0,
				Pitch = 1.0
			},
			{
				File = "ambience/terrain/coast_seagull_00.wav",
				Volume = 1.0,
				Pitch = 1.0
			},
			{
				File = "ambience/terrain/coast_seagull_01.wav",
				Volume = 1.0,
				Pitch = 1.0
			},
			{
				File = "ambience/terrain/coast_seagull_02.wav",
				Volume = 1.0,
				Pitch = 1.0
			},
			{
				File = "ambience/terrain/coast_seagull_03.wav",
				Volume = 1.0,
				Pitch = 1.0
			},
			{
				File = "ambience/terrain/coast_seagull_04.wav",
				Volume = 1.0,
				Pitch = 1.0
			},
			{
				File = "ambience/terrain/coast_seagull_05.wav",
				Volume = 1.0,
				Pitch = 1.0
			},
			{
				File = "ambience/terrain/coast_small_waves_00.wav",
				Volume = 1.0,
				Pitch = 1.0
			},
			{
				File = "ambience/terrain/coast_small_waves_01.wav",
				Volume = 1.0,
				Pitch = 1.0
			},
			{
				File = "ambience/terrain/coast_small_waves_02.wav",
				Volume = 1.0,
				Pitch = 1.0
			},
			{
				File = "ambience/terrain/coast_small_waves_03.wav",
				Volume = 1.0,
				Pitch = 1.0
			},
			{
				File = "ambience/terrain/coast_small_waves_04.wav",
				Volume = 1.0,
				Pitch = 1.0
			},
			{
				File = "ambience/terrain/coast_small_waves_05.wav",
				Volume = 1.0,
				Pitch = 1.0
			}
		];
		this.m.SoundsAtNight = [
			{
				File = "ambience/buildings/docks_rope_00.wav",
				Volume = 1.0,
				Pitch = 1.0
			},
			{
				File = "ambience/buildings/docks_rope_01.wav",
				Volume = 1.0,
				Pitch = 1.0
			}
		];
	}

	function onClicked( _townScreen )
	{
		if (this.World.Contracts.getActiveContract() != null && this.World.Contracts.getActiveContract().getType() == "contract.escort_caravan")
		{
			return;
		}

		_townScreen.getTravelDialogModule().setData(this.getUITravelRoster());
		_townScreen.showTravelDialog();
		this.pushUIMenuStack();
	}

	function onSettlementEntered()
	{
	}

	function getUITravelRoster()
	{
		local data = {
			Title = "Port",
			SubTitle = "Un port qui permet de se déplacer par bateau vers d\'autres parties du continent.",
			HeaderImage = null,
			Roster = []
		};
		local settlements = this.World.EntityManager.getSettlements();

		foreach( s in settlements )
		{
			if (!s.hasBuilding("building.port"))
			{
				continue;
			}

			if (s.getID() == this.m.Settlement.getID())
			{
				continue;
			}

			if (!s.isAlliedWithPlayer() || !this.m.Settlement.getOwner().isAlliedWith(s.getFaction()))
			{
				continue;
			}

			local dest = {
				ID = s.getID(),
				EntryID = data.Roster.len(),
				ListName = "Voyager vers " + s.getName(),
				Name = s.getName(),
				Cost = this.getCostTo(s),
				ImagePath = s.getImagePath(),
				ListImagePath = s.getImagePath(),
				FactionImagePath = s.getOwner().getUIBannerSmall(),
				BackgroundText = s.getDescription() + "<br><br>" + this.getRandomDescription(s.getName())
			};
			data.Roster.push(dest);
		}

		return data;
	}

	function getRandomDescription( _destinationName )
	{
		local desc = "{Un navire rapide | Un navire solide | Un engin | Un long navire| Un petit navire | Un navire de commerce | Un knarr | Un bateau de pêche local | Un vieux navire grinçant} au nom de \'%shipname%\' {qui prendra votre compagnie à bord jusqu\'à %destname% | se trouve à naviguer vers %destname% et accepterait votre compagnie à bord | iest sur le point de partir et pourrait être un moyen de se rendre rapidement à %destname% | pourrait constituer un moyen d\'atteindre %destname% beaucoup plus rapidement que par la voie terrestre | pourrait vous déposer à %destname% pour une bourse complète de couronnes}.";
		local vars = [
			[
				"shipname",
				this.Const.Strings.ShipNames[this.Math.rand(0, this.Const.Strings.ShipNames.len() - 1)]
			],
			[
				"destname",
				_destinationName
			]
		];
		return this.buildTextFromTemplate(desc, vars);
	}

	function getCostTo( _to )
	{
		local myTile = this.getSettlement().getTile();
		local dist = _to.getTile().getDistanceTo(myTile);
		local cost = dist * this.World.getPlayerRoster().getSize() * 0.5;
		cost = this.Math.round(cost * 0.1);
		cost = cost * 10.0;
		return cost;
	}

	function onSerialize( _out )
	{
		this.building.onSerialize(_out);
	}

	function onDeserialize( _in )
	{
		this.building.onDeserialize(_in);
	}

});

