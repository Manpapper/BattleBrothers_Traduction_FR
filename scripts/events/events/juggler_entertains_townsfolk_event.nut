this.juggler_entertains_townsfolk_event <- this.inherit("scripts/events/event", {
	m = {
		Juggler = null,
		Town = null
	},
	function create()
	{
		this.m.ID = "event.juggler_entertains_townsfolk";
		this.m.Title = "À %townname%";
		this.m.Cooldown = 50.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_92.png[/img]Alors que les hommes errent dans %townname% à la recherche de choses à faire, %juggler% le jongleur prend sur lui de fournir son propre divertissement. Il prend un parchemin et le plie en un chapeau de papier avec des cornes. Le plaçant sur sa tête, il se glisse ensuite dans une foule de paysans et leur demande de quoi jongler. Ils lui lancent toutes sortes d\'objets, des carottes aux couteaux, et un homme offre même un nouveau-né avant que la mère ne le gifle pour l\'avoir suggéré. Quel que soit l\'objet lancé, le jongleur le projette facilement dans les airs, son propre corps se tordant et tournant, ses pieds alternant entre les mains pour renvoyer les objets dans les airs. C\'est une poésie artistique en mouvement - et une aubaine pour les opprimés de la ville. On a l\'impression que le jongleur a bien représenté %companyname% ce jour-là.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Bien joué, bien joué.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Juggler.getImagePath());

				if (_event.m.Town.isSouthern())
				{
					_event.m.Town.getOwner().addPlayerRelation(this.Const.World.Assets.RelationCivilianContractSuccess, "un de vos hommes a diverti les masses");
				}
				else
				{
					_event.m.Town.getFactionOfType(this.Const.FactionType.Settlement).addPlayerRelation(this.Const.World.Assets.RelationCivilianContractSuccess, "Un de vos hommes a diverti les habitants de la ville.");
				}

				_event.m.Juggler.improveMood(2.0, "A diverti les habitants de la ville avec ses tours de jongleur");

				if (_event.m.Juggler.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Juggler.getMoodState()],
						text = _event.m.Juggler.getName() + this.Const.MoodStateEvent[_event.m.Juggler.getMoodState()]
					});
				}
			}

		});
	}

	function onUpdateScore()
	{
		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 2)
		{
			return;
		}

		local candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.juggler")
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

		this.m.Juggler = candidates[this.Math.rand(0, candidates.len() - 1)];
		this.m.Town = town;
		this.m.Score = candidates.len() * 15;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"juggler",
			this.m.Juggler.getNameOnly()
		]);
		_vars.push([
			"town",
			this.m.Town.getNameOnly()
		]);
		_vars.push([
			"townname",
			this.m.Town.getNameOnly()
		]);
	}

	function onClear()
	{
		this.m.Juggler = null;
		this.m.Town = null;
	}

});

