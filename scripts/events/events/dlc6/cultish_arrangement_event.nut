this.cultish_arrangement_event <- this.inherit("scripts/events/event", {
	m = {
		Cultist = null
	},
	function create()
	{
		this.m.ID = "event.cultish_arrangement";
		this.m.Title = "Sur la route...";
		this.m.Cooldown = 99999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_03.png[/img]{Vous passez par-dessus une dune de sable pour voir une demi-douzaine d\'hommes. Ils portent des capes noires et leurs mains gainées de manches se tiennent les unes aux autres pour former un cercle complet. Bien qu\'ils aient tous la tête baissée, ils semblent sentir votre présence et se tournent pour vous fixer. Un homme lâche ses mains et s\'avance.%SPEECH_ON%Davkul nous attend tous, voyageur, même le chemin doré permet sa patience.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Nous vous laissons les gars.",
					function getResult( _event )
					{
						return "D";
					}

				}
			],
			function start( _event )
			{
				if (_event.m.Cultist != null)
				{
					this.Options.push({
						Text = "Parlez à vos frères dans la foi, %cultistes%.",
						function getResult( _event )
						{
							return "C";
						}

					});
				}

				this.Options.push({
					Text = "Abattez ces imbéciles !",
					function getResult( _event )
					{
						return "B";
					}

				});
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_12.png[/img]{Vous dégainez votre épée et ordonnez à la compagnie de s\'occuper rapidement des cultistes. Ils sont attaqués avec facilité, les cultistes ne lèvent même pas la main pour résister à leur propre mort. Un survivant tousse en laissant saigner une blessure ouverte. Il tend la main comme pour vous montrer votre travail.%SPEECH_ON% Malgré tout votre travail, vous ne pouvez pas gagner du temps, Mercenaire. Davkul nous attend tous.%SPEECH_OFF%Tu sors ta dague et tu achèves l\'homme. Vous donnez un coup de pied à son corps et le pillez, ainsi que les autres cadavres, bien qu\'il n\'y ait pas grand chose à trouver.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Allons-y.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.Assets.addMoralReputation(-2);
				local money = this.Math.rand(10, 100);
				this.World.Assets.addMoney(money);
				this.List = [
					{
						id = 10,
						icon = "ui/icons/asset_money.png",
						text = "Vous recevez [color=" + this.Const.UI.Color.PositiveEventValue + "]" + money + "[/color] Couronnes"
					}
				];
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_03.png[/img]{%cultist% s\'avance, brandissant sa tête balafrée pour que tous les étrangers puissent la voir. Ils hochent la tête et s\'inclinent, et leur chef parle en regardant le sables. %SPEECH_ON%Davkul a parlé.%SPEECH_OFF%Hochant la tête, %cultist% répond.%SPEECH_ON%Et à chaque mot j\'écoute.%SPEECH_OFF%Le chef récupère une étrange lame apparemment sortie de nulle part et la passe entre ses doigts. Il parle à nouveau sans lever les yeux.%SPEECH_ON% Alors faites ce qu\'il demande.%SPEECH_OFF% %cultist% prend la lame et hoche la tête.%SPEECH_ON%Davkul nous attend tous.%SPEECH_OFF%Les hommes étranges s\'effondrent sur le sol et mettent leur visage dans le sable. Leurs poitrines se soulèvent et s\'abaissent, tremblent, puis ils ne bougent plus. Ils se sont noyés dans le désert lui-même. L\'%cultist% revient en emportant une étrange dague.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "D\'accord...",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Cultist.getImagePath());
				local item = this.new("scripts/items/weapons/oriental/qatal_dagger");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Vous recevez a " + item.getName()
				});
				_event.m.Cultist.improveMood(1.0, "Il s\'entendait avec ses frères dans la foi");

				if (_event.m.Cultist.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Cultist.getMoodState()],
						text = _event.m.Cultist.getName() + this.Const.MoodStateEvent[_event.m.Cultist.getMoodState()]
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_03.png[/img]{Vous offrez un modeste bonjour et un au revoir aux manteaux noirs, puis vous partez. Ils ne vous résistent pas et ne vous interpellent pas de quelque manière que ce soit. La dernière fois que vous les avez vus, ils se tenaient à nouveau par la main, la tête penchée en avant et le regard fixé sur les sables. Il n\'y a pas une seule cruche d\'eau ou un seul panier de nourriture. S\'ils ne sont pas venus ici pour mourir, qu\'est-ce qui pourrait bien les sauver ?}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "On ne doit pas le savoir, peut-être.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Desert)
		{
			return;
		}

		if (this.World.getTime().Days < 10)
		{
			return;
		}

		if (this.World.getTime().IsDaytime)
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();

		if (currentTile.Type != this.Const.World.TerrainType.Desert)
		{
			return;
		}

		if (!this.World.Assets.getStash().hasEmptySlot())
		{
			return;
		}

		local towns = this.World.EntityManager.getSettlements();

		foreach( t in towns )
		{
			if (t.getTile().getDistanceTo(currentTile) <= 7)
			{
				return;
			}
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local candidates_cultist = [];

		foreach( bro in brothers )
		{
			if (bro.getSkills().hasSkill("trait.player"))
			{
				continue;
			}

			if (bro.getBackground().getID() == "background.cultist" || bro.getBackground().getID() == "background.converted_cultist")
			{
				candidates_cultist.push(bro);
			}
		}

		if (candidates_cultist.len() != 0)
		{
			this.m.Cultist = candidates_cultist[this.Math.rand(0, candidates_cultist.len() - 1)];
		}

		this.m.Score = 5;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"cultist",
			this.m.Cultist != null ? this.m.Cultist.getNameOnly() : ""
		]);
	}

	function onClear()
	{
		this.m.Cultist = null;
	}

});

