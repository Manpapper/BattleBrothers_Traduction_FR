this.eunuch_ladies_event <- this.inherit("scripts/events/event", {
	m = {
		Eunuch = null,
		Town = null
	},
	function create()
	{
		this.m.ID = "event.eunuch_ladies";
		this.m.Title = "À %town%";
		this.m.Cooldown = 50.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_85.png[/img]La rumeur se répand sur %eunuch% l\'eunuque. Apparemment, lui et quelques frères ont visité le bordel de la ville. Les putes et les frères se sont d\'abord moqués de l\'eunuque, mais il n\'a exigé que cinq minutes avec la plus expérimentée des dames. Elle est ressortie au bout de deux minutes et les rumeurs sur les prouesses au lit de l\'eunuque n\'ont fait qu\'exploser à partir de là.\n\nMaintenant, la moitié de la ville, plus précisément les femmes, ne tarissent pas d\'éloges sur %companyname% et aimeraient vous voir revenir. %eunuch% lui-même vous fait un clin d\'œil et un sourire. Vous remarquez qu\'il est plutôt verruqueux au niveau des lèvres.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Un talent caché.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Eunuch.getImagePath());

				if (_event.m.Town.isSouthern())
				{
					_event.m.Town.getOwner().addPlayerRelation(this.Const.World.Assets.RelationCivilianContractSuccess, "Un de vos hommes a obtenu une bonne réputation avec les dames");
				}
				else
				{
					_event.m.Town.getFactionOfType(this.Const.FactionType.Settlement).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractSuccess, "Un de vos hommes a obtenu une bonne réputation avec les dames");
				}

				_event.m.Eunuch.improveMood(1.5, "A sympathisé avec des dames de " + _event.m.Town.getName());

				if (_event.m.Eunuch.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Eunuch.getMoodState()],
						text = _event.m.Eunuch.getName() + this.Const.MoodStateEvent[_event.m.Eunuch.getMoodState()]
					});
				}
			}

		});
	}

	function onUpdateScore()
	{
		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 3)
		{
			return;
		}

		local candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getLevel() >= 3 && bro.getBackground().getID() == "background.eunuch")
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() == 0)
		{
			return;
		}

		local towns = this.World.EntityManager.getSettlements();
		local nearTown = false;
		local town;
		local playerTile = this.World.State.getPlayer().getTile();

		foreach( t in towns )
		{
			if (t.isMilitary())
			{
				continue;
			}

			if (t.getTile().getDistanceTo(playerTile) <= 3 && t.isAlliedWithPlayer())
			{
				nearTown = true;
				town = t;
				break;
			}
		}

		if (!nearTown)
		{
			return;
		}

		this.m.Eunuch = candidates[this.Math.rand(0, candidates.len() - 1)];
		this.m.Town = town;
		this.m.Score = candidates.len() * 15;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"eunuch",
			this.m.Eunuch.getNameOnly()
		]);
		_vars.push([
			"town",
			this.m.Town.getNameOnly()
		]);
	}

	function onClear()
	{
		this.m.Eunuch = null;
		this.m.Town = null;
	}

});

