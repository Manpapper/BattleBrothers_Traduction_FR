this.holywar_neutral_nomads_event <- this.inherit("scripts/events/event", {
	m = {
		Wildman = null
	},
	function create()
	{
		this.m.ID = "event.holywar_neutral_nomads";
		this.m.Title = "Sur la route...";
		this.m.Cooldown = 200.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_170.png[/img]{Vous rencontrez une bande de nomades. Malgré la gravité de la guerre en cours, ils ne vous traitent pas comme une menace. L'un d'entre eux vous accueille avec une boisson et l'ombre d'une ombrelle que vous acceptez.%SPEECH_ON% J'espère que vos voyages ont été agréables, Crownling. Vous partagez une similitude avec nous, coureurs des dunes, celle de l'intrus. Les griefs entre le nord et le sud n'ont pas à nous concerner.%SPEECH_OFF%Il boit une gorgée de sa propre boisson et hoche la tête.%SPEECH_ON%Je soupçonne que vous avez gagné beaucoup d'argent dans le conflit. Certains de mes compatriotes vous considèrent comme le plus fidèle au doreur à cause de cela.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [],
			function start( _event )
			{
				this.Options.push({
					Text = "Vous ne suivez pas les croyances de vos compatriotes?",
					function getResult( _event )
					{
						return "B";
					}

				});

				if (_event.m.Wildman != null)
				{
					this.Options.push({
						Text = "Que fait %wildmanfull% là-bas?",
						function getResult( _event )
						{
							return "D";
						}

					});
				}

				this.Options.push({
					Text = "Et je suis sur le point d'en faire encore plus après ta mort.",
					function getResult( _event )
					{
						return "C";
					}

				});
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_170.png[/img]{Le nomade rit.%SPEECH_ON%En matière de foi, pourquoi quelqu'un penserait de la même façon?%SPEECH_OFF%Il rassemble ses tapis et ses ombrelles.%SPEECH_ON%J'ai entendu dire dans le nord qu'il y a des hommes sauvages comme nous.%SPEECH_OFF%Vous pincez les lèvres, retenu un rire.%SPEECH_ON%Nous avons des hommes de la forêt qui ont fui la civilisation, oui. Mais ils sont d'une espèce plus... particulière que vous et les vôtres. Ils ne sont pas tellement comme toi.%SPEECH_OFF%En hochant la tête, le nomade te donne un cadeau.%SPEECH_ON%Mais peut-être qu'ils le sont et que tu ne les as pas écoutés.%SPEECH_OFF%Il se touche la poitrine avec un poing puis les nomades continuent leur voyage.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Merci pour votre hospitalité.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local item = this.new("scripts/items/supplies/dates_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Vous recevez " + item.getName()
				});
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					bro.improveMood(0.5, "Apprécié l'hospitalité des nomades");

					if (bro.getMoodState() >= this.Const.MoodState.Neutral)
					{
						this.List.push({
							id = 10,
							icon = this.Const.MoodStateIcon[bro.getMoodState()],
							text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
						});
					}
				}
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_170.png[/img]{Vous finissez votre verre et dites à l'homme que le temps passé avec lui était très intéressant. Il va vous serrer la main et vous lui transpercez de votre l'épée. Le reste de la compagnie se joint à vous et la bataille est aussi brève que votre sens de l'hospitalité. Les nomades n'ont pas grand-chose de valable dans leur propriété, mais personne ne saura ce que vous avez fait ici, bien qu'il soit peu probable qu'ils s'en soucient de toute façon.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Prenez tout ce que nous pouvons utiliser",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.Assets.addMoralReputation(-2);
				local money = 150;
				this.World.Assets.addMoney(money);
				this.List = [
					{
						id = 10,
						icon = "ui/icons/asset_money.png",
						text = "Vous recevez [color=" + this.Const.UI.Color.PositiveEventValue + "]" + money + "[/color] Couronnes"
					}
				];
				local item = this.new("scripts/items/supplies/dates_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Vous recevez " + item.getName()
				});
				item = this.new("scripts/items/supplies/rice_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Vous recevez " + item.getName()
				});
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getBackground().isOffendedByViolence() && this.Math.rand(1, 100) <= 75)
					{
						bro.worsenMood(0.75, "Je n'ai pas aimé que vous ayez tué et volé vos hôtes.");

						if (bro.getMoodState() < this.Const.MoodState.Neutral)
						{
							this.List.push({
								id = 10,
								icon = this.Const.MoodStateIcon[bro.getMoodState()],
								text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
							});
						}
					}
				}
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_170.png[/img]{%wildman% le sauvageon s'avance sous l'ombrelle. Le nomade le regarde, et le sauvageon regarde le nomade. Vous demandez s'ils se connaissent. Le nomade sourit. %SPEECH_ON%Non, mais oui. Nous sommes des âmes sœurs. Je peux le voir dans ses yeux.%SPEECH_OFF% Le sauvageon hulule et grogne, puis se retourne et part. Quand tu retournes ton regard vers le nomade, il te tend une dague dorée.%SPEECH_ON%Les trésors, l'or, ces choses qui brillent et attirent l'œil de l'homme, ils ont peu de valeur pour moi. Je l'ai trouvé sur l'un des gardes du Vizir. Nous les avions tués, lui et sa caravane, pour leur nourriture et leur eau, les choses qui me semblent les plus importantes. Tu peux avoir la dague, ce n'est rien de plus qu'un cadeau. %SPEECH_OFF% Tu la prends, et le previens que s'il te tend une embuscade comme il l'a fait avec les hommes du Vizir, tu utiliseras peut-être cette même dague contre lui. Le nomade hoche la tête. %SPEECH_ON%Et pourtant c'est toujours mon cadeau. Je trouverais l'occasion si ironique que ce ne pourrait être qu'un plaisir de mourir de cette manière. Il y a de pires façons de mourir dans le désert, mon ami.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Merci pour votre générosité.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Wildman.getImagePath());
				local item = this.new("scripts/items/weapons/oriental/qatal_dagger");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Vous recevez " + item.getName()
				});
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					bro.improveMood(0.5, "Apprécié l'hospitalité des nomades");

					if (bro.getMoodState() >= this.Const.MoodState.Neutral)
					{
						this.List.push({
							id = 10,
							icon = this.Const.MoodStateIcon[bro.getMoodState()],
							text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
						});
					}
				}
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Desert)
		{
			return;
		}

		if (!this.World.FactionManager.isHolyWar())
		{
			return;
		}

		if (this.World.Assets.getOrigin().getID() == "scenario.manhunters" || this.World.Assets.getOrigin().getID() == "scenario.gladiators" || this.World.Assets.getOrigin().getID() == "scenario.southern_quickstart")
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();

		if (currentTile.Type != this.Const.World.TerrainType.Desert && currentTile.TacticalType != this.Const.World.TerrainTacticalType.DesertHills)
		{
			return;
		}

		if (currentTile.HasRoad)
		{
			return;
		}

		local towns = this.World.EntityManager.getSettlements();

		foreach( t in towns )
		{
			if (t.getTile().getDistanceTo(currentTile) <= 6)
			{
				return;
			}
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local candidates_wildman = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.wildman")
			{
				candidates_wildman.push(bro);
			}
		}

		if (candidates_wildman.len() != 0)
		{
			this.m.Wildman = candidates_wildman[this.Math.rand(0, candidates_wildman.len() - 1)];
		}

		this.m.Score = 10;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"wildman",
			this.m.Wildman != null ? this.m.Wildman.getNameOnly() : ""
		]);
		_vars.push([
			"wildmanfull",
			this.m.Wildman != null ? this.m.Wildman.getName() : ""
		]);
	}

	function onClear()
	{
		this.m.Wildman = null;
	}

});

