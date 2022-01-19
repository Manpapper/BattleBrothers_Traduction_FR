this.civilwar_dead_knight_event <- this.inherit("scripts/events/event", {
	m = {
		Thief = null
	},
	function create()
	{
		this.m.ID = "event.crisis.civilwar_dead_knight";
		this.m.Title = "Le long de la route...";
		this.m.Cooldown = 100.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_97.png[/img]Vous rencontrez une foule d\'enfants qui se bousculent autour de quelque chose dans l\'herbe comme des mouches sur un tas de merde. %randombrother% commence à les disperser.%SPEECH_ON%Bande de garnements et vos blagues, décampez ! Oh putain. Monsieur, venez jeter un oeil !%SPEECH_OFF%Un gros gamin au visage gras vous crie dessus.%SPEECH_ON%Je l\'ai trouvé le premier ! C\'est à moi !%SPEECH_OFF%Vous l\'écartez sans effort et jetez un oeil. Il y a un chevalier mort dans l\'herbe et il est sans doute là depuis un moment. Un doux bruit sort de son armure alors que les fourmis rampent dessus. Une petite fille se tient le nez pincée. La voie un peu nasillarde et aiguë, elle s\'essaye à une diplomatie astucieuse.%SPEECH_ON%Laissez-les faire, Robbie ! Ces hommes sont dangereux ! N\'êtes-ce pas ? N\'êtes-vous pas des hommes dangereux ?%SPEECH_OFF%%randombrother% dégaine son arme et la fait tourner de façon spectaculaire.%SPEECH_ON%La gamine a raison ! Vous êtes tous les meilleurs connards avant de vous étaler dans la boue comme ce chevalier ! C\'est vrai, nous sommes ses assassins et nous sommes revenus pour voir notre travail!%SPEECH_OFF%Criant et pleurant, les enfants sont dispersés comme des oiseaux sur un arbre. Robbie reste derrière, regardant par-dessus un buisson ses trésors perdus. Vous dites au mercenaire qu\'il n\'avait pas besoin de les effrayer autant. Il hausse les épaules et commence à ramasser l\'équipement du chevalier.",
			Banner = "",
			Characters = [],
			Options = [
				{
					Text = "Toujours utile.",
					function getResult( _event )
					{
						if (_event.m.Thief != null)
						{
							return "Thief";
						}
						else
						{
							return 0;
						}
					}

				}
			],
			function start( _event )
			{
				local item = this.new("scripts/items/helmets/faction_helm");
				item.setCondition(27.0);
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Vous récupérez " + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
			}

		});
		this.m.Screens.push({
			ID = "Thief",
			Text = "[img]gfx/ui/events/event_97.png[/img]%thief% Vous surveillez Robbie et vous remarquez qu\'il commence à transpirer. Le mercenaire le pointe du doigt.%SPEECH_ON%Tu n\'es pas qu\'une grosse merde, gamin. Que caches-tu sous ta chemise ? Tu ne tromperas pas un voleur, allez, montrez-le!%SPEECH_OFF%En soupirant, Robbie soulève sa chemise et un tas de couronnes vont claquer dans l\'herbe. L\'homme hoche la tête.%SPEECH_ON%C\'est ce que je pensais. Maintenant dégage.%SPEECH_OFF%",
			Banner = "",
			Characters = [],
			List = [],
			Options = [
				{
					Text = "Bonne vue",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Thief.getImagePath());
				local money = this.Math.rand(30, 150);
				this.World.Assets.addMoney(money);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Vous ramassez [color=" + this.Const.UI.Color.PositiveEventValue + "]" + money + "[/color] Couronnes"
				});
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.World.FactionManager.isCivilWar())
		{
			return;
		}

		if (!this.World.State.getPlayer().getTile().HasRoad)
		{
			return;
		}

		local towns = this.World.EntityManager.getSettlements();
		local playerTile = this.World.State.getPlayer().getTile();
		local nearTown = false;

		foreach( t in towns )
		{
			if (t.isSouthern())
			{
				continue;
			}

			if (t.getTile().getDistanceTo(playerTile) <= 10 && t.getTile().getDistanceTo(playerTile) >= 4 && t.isAlliedWithPlayer())
			{
				nearTown = true;
				break;
			}
		}

		if (!nearTown)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.thief" || bro.getSkills().hasSkill("trait.eagle_eyes"))
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() != 0)
		{
			this.m.Thief = candidates[this.Math.rand(0, candidates.len() - 1)];
		}

		this.m.Score = 10;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"thief",
			this.m.Thief != null ? this.m.Thief.getName() : ""
		]);
	}

	function onClear()
	{
		this.m.Thief = null;
	}

});

