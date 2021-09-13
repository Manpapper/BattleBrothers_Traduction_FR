this.sickness_event <- this.inherit("scripts/events/event", {
	m = {
		SomeGuy = null
	},
	function create()
	{
		this.m.ID = "event.sickness";
		this.m.Title = "Sur la route...";
		this.m.Cooldown = 21.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_09.png[/img] {Le marais s\'agrippe à chacun de vos pas, tant il veut vous retenir. Alors que vos bottes s\'enfoncent dans la boue, %someguy% se retourne et vomit soudainement, ajoutant son petit-déjeuner à la tourbière. Vous vous retournez pour voir un autre frère d\'arme au loin se retourner, laissant échapper de sa bouche un grand vomissement qui vous fait suffoquer vous-même. companyname% expriment leur malaise collectif tandis que d\'autres hommes vomissent et s\'étouffent. Ce n\'est vraiment pas un endroit où l\'homme doit être. | Bien qu\'il grouille de formes de vie dégoûtantes, le marais sent en fait la mort délétère. Une vapeur apparemment toxique ondule sur les eaux calmes du marais. Elle vous brûle les yeux et la gorge et empoisonne tous vos aliments en leur donnant mauvais goût. Quelles sont les choses immondes qui osent vivre ici ? Vous voyez des crapauds, des serpents et des créatures qui ont certainement été touchées par le diable lors de leur naissance. les membres de %companyname% tombent tous malades dans cet endroit maudit. Seuls les plus forts peuvent avoir les tripes pour le supporter, tous les autres ont déjà des haut-le-coeur et voient des choses qui ne sont pas là.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Maudit soit cet endroit !",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.List = _event.giveSicknessEffect();
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_08.png[/img] Votre souffle apparaît devant vous comme s\'il était gelé sur place. Ça a commencé lentement, cette douleur. Des crachats de neige. Des vents qui venaient d\'anciens glaciers. Un pas a enfoncé votre pied profondément dans la poudre blanche et c\'est alors que vous avez su que le reste du voyage serait une épreuve d\'endurance.\n\nVous vous demandez comment les hommes d\'autrefois faisaient, en vivant dans ces régions. Ils s\'asseyaient autour d\'un feu de camp avec le monde entier à leurs trousses. Assis dans l\'obscurité, entourés de rafales de glace. Assis dans l\'isolement. Ils sont nés ici, ça a devait être leur truc. L\'ignorance était leur chaleur. Seul un homme qui ne connaît rien de mieux pourrait vivre dans un endroit comme celui-ci.\n\nLes hommes de %companyname% titubent et tombent et ne se relèvent pas aussi vite qu\'avant. Quelques-uns sont pris de quintes de toux et d\'autres semblent prêts à succomber à l\'épuisement. Seuls les plus forts d\'entre eux continuent sans problème. Ce sont ces hommes qui ont sûrement un lien avec les ancêtres de cette horrible terre.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Maudit soit cet endroit !",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.List = _event.giveSicknessEffect();
			}

		});
	}

	function giveSicknessEffect()
	{
		local brothers = this.World.getPlayerRoster().getAll();
		local result = [];
		local lowestChance = 9000;
		local lowestBro;
		local applied = false;

		foreach( bro in brothers )
		{
			if (bro.getSkills().hasSkill("effects.sickness"))
			{
				continue;
			}

			local chance = bro.getHitpoints() + 20;

			if (bro.getSkills().hasSkill("trait.strong"))
			{
				chance = chance + 20;
			}

			if (bro.getSkills().hasSkill("trait.tough"))
			{
				chance = chance + 20;
			}

			if (bro.getSkills().hasSkill("trait.lucky"))
			{
				chance = chance + 20;
			}

			if (this.m.SomeGuy.getID() != bro.getID() && this.Math.rand(1, 100) < chance)
			{
				if (chance < lowestChance)
				{
					lowestChance = chance;
					lowestBro = bro;
				}

				continue;
			}

			applied = true;
			local effect = this.new("scripts/skills/injury/sickness_injury");
			bro.getSkills().add(effect);
			result.push({
				id = 10,
				icon = effect.getIcon(),
				text = bro.getName() + " est malade"
			});
		}

		if (!applied && lowestBro != null)
		{
			local effect = this.new("scripts/skills/injury/sickness_injury");
			lowestBro.getSkills().add(effect);
			result.push({
				id = 10,
				icon = effect.getIcon(),
				text = lowestBro.getName() + " est malade"
			});
		}

		return result;
	}

	function onUpdateScore()
	{
		if (this.World.Retinue.hasFollower("follower.scout"))
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();

		if (currentTile.Type != this.Const.World.TerrainType.Swamp && currentTile.Type != this.Const.World.TerrainType.Snow && currentTile.Type != this.Const.World.TerrainType.SnowyForest)
		{
			return;
		}

		local towns = this.World.EntityManager.getSettlements();
		local playerTile = this.World.State.getPlayer().getTile();

		foreach( t in towns )
		{
			if (t.getTile().getDistanceTo(playerTile) <= 4)
			{
				return;
			}
		}

		local brothers = this.World.getPlayerRoster().getAll();
		this.m.SomeGuy = brothers[this.Math.rand(0, brothers.len() - 1)];
		this.m.Score = 10;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"someguy",
			this.m.SomeGuy.getName()
		]);
	}

	function onDetermineStartScreen()
	{
		local currentTile = this.World.State.getPlayer().getTile();

		if (currentTile.Type == this.Const.World.TerrainType.Swamp)
		{
			return "A";
		}
		else if (currentTile.Type == this.Const.World.TerrainType.Snow || currentTile.Type == this.Const.World.TerrainType.SnowyForest)
		{
			return "B";
		}
	}

	function onClear()
	{
		this.m.SomeGuy = null;
	}

});

