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
		this.m.Name = "Harbor";
		this.m.UIImage = "ui/settlements/building_09";
		this.m.UIImageNight = "ui/settlements/building_09_night";
		this.m.Tooltip = "world-town-screen.main-dialog-module.Port";
		this.m.TooltipIcon = "ui/icons/buildings/harbor.png";
		this.m.Description = "A harbor that serves both foreign trading ships and local fishermen";
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
			Title = "Harbor",
			SubTitle = "A harbor that allows you to book passage by ship to other parts of the continent",
			HeaderImage = null,
			Roster = []
		};
		local settlements = this.World.EntityManager.getSettlements();

		foreach( s in settlements )
		{
			if (!s.isCoastal())
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
				ListName = "Sail to " + s.getName(),
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
		local desc = "{A fast ship | A sturdy ship | A cog | A longship | A small ship | A trading ship | A knarr | A local fishing boat | A creaking old ship} by the name of \'%shipname%\' {would take your company onboard and to %destname% | happens to sail to %destname% and would take your company onboard | is soon to depart and could be a way to safely and quickly make passage to %destname% | could provide a means to reach %destname% a lot faster than going overland | could drop you off at %destname% for a full purse of crowns}.";
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

