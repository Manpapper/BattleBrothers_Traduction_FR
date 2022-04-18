this.retired_gladiator_event <- this.inherit("scripts/events/event", {
	m = {
		Dude = null,
		Gladiator = null,
		Name = null,
		Town = null
	},
	function create()
	{
		this.m.ID = "event.retired_gladiator";
		this.m.Title = "At %townname%...";
		this.m.Cooldown = 999999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_163.png[/img]{Vous croisez un vieil homme dans la rue. Il ne serait pas particulièrement remarquable, si ce n\'est qu\'il est propriétaire d\'un équipement particulièrement beau. Un peu usé et déchiré, mais sympa. Et, bien sûr, le fait qu\'il soit un ancien et qu\'on ne lui ait pas volé ces objets est la preuve qu\'il se passe quelque chose d\'autre ici.%SPEECH_ON% Le mercenaire regarde, le mercenaire s\'interroge.%SPEECH_OFF% L\'homme dit en mordant dans une miche de pain. Il lève les yeux vers toi.%SPEECH_ON%Mon nom est %retired%. J\'ai déjà combattu dans les arènes, mais je me suis retiré il y a cinq ans. Pas par choix, d\'ailleurs. On m\'a chargé de truquer un match, mais à la place j\'ai coupé la tête de l\'adversaire. Cet adversaire était le fils d\'un vizir. Ce détail particulier n\'a pas été partagé avec moi à l\'époque. Ces cinq années dont j\'ai parlé ? Je les ai passées dans un donjon.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Nous aurions besoin de vous.",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "Eh bien, bonne chance à vous.",
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
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_163.png[/img]{Vous lui dites que vous auriez besoin de lui dans le %companyname%. Il rit.%SPEECH_ON%Les jours de combat me dépassent un peu. Je cherche à vendre cette armure au prix coûtant et à quitter cette ville pour toujours. %SPEECH_OFF%Il incline l\'armure vers l\'avant. %SPEECH_ON%Vous ne trouverez nulle part un tel équipement. Tout ce que je demande, c\'est 1 000 couronnes, un harnais de gladiateur tel que vous aurez du mal à en trouver dans n\'importe quelle boutique de forgeron.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Nous prenons l\'armure pour 1 000 couronnes.",
					function getResult( _event )
					{
						return "BuyArmor";
					}

				},
				{
					Text = "Non, merci, c\'est bon.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				if (_event.m.Gladiator != null)
				{
					this.Options.push({
						Text = "Peut-être que %gladiator% pourra vous convaincre de vous joindre à nous.",
						function getResult( _event )
						{
							return "Gladiator";
						}

					});
				}
			}

		});
		this.m.Screens.push({
			ID = "BuyArmor",
			Text = "[img]gfx/ui/events/event_163.png[/img]{Vous lui donnez l\'or et il vous donne l\'armure. Il pèse la bourse de couronnes. Je suppose que cela suffira pour ma retraite. Il vaut mieux me laisser les armes. Ce n\'est pas une terre particulièrement sûre, après tout, et même un vieil homme aussi dangereux que moi pourrait avoir besoin de protection.%SPEECH_OFF%Il a raison sur ce point. Vous lui souhaitez bonne chance et mettez l\'armure dans l\'inventaire.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Voyages en toute sécurité.

",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local a = this.new("scripts/items/armor/oriental/gladiator_harness");
				local u = this.new("scripts/items/armor_upgrades/heavy_gladiator_upgrade");
				a.setUpgrade(u);
				this.List.push({
					id = 12,
					icon = "ui/items/armor_upgrades/upgrade_25.png",
					text = "Vous recevez a " + a.getName()
				});
				this.World.Assets.getStash().add(a);
				this.World.Assets.addMoney(-1000);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Vous perdez  [color=" + this.Const.UI.Color.NegativeEventValue + "]1,000[/color] Couronnes"
				});
			}

		});
		this.m.Screens.push({
			ID = "Gladiator",
			Text = "[img]gfx/ui/events/event_163.png[/img]{%gladiator% laughs.%SPEECH_ON%Friend, J\'étais autrefois un gladiateur. Viens avec nous et traite le monde entier comme ton arène. Je sais que ça te démange. Je sais que c\'est quelque part là-dedans. Trouve-la. Cette joie de tuer. Cette énergie de la victoire. Partage-la avec nous, une bande de frères de bataille. L\'ancien gladiateur regarde son équipement. Son reflet le regarde en retour, bien que brouillé et déformé par la saleté et les bosses. Il hoche la tête. %SPEECH_ON%Vous avez raison. Mais à quoi je pense, nom d\'une pipe ? J\'ai été pauvre, énervé et énervé pendant trop longtemps. Si votre compagnie veut de moi, alors je finirai mes jours comme je les ai vécus : en tuant !%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Bienvenue à bord.",
					function getResult( _event )
					{
						return "Recruit";
					}

				},
				{
					Text = "Non, merci.",
					function getResult( _event )
					{
						return "Deny";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Gladiator.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "Recruit",
			Text = "[img]gfx/ui/events/event_163.png[/img]{Accueillez l\'homme à bord. Il se lève. J\'aimerais me battre avec mon propre matériel, mais je n\'ai pas de préférence. Après tout, j\'essayais juste de le vendre, non ? Donnez-moi ce que vous pensez être le meilleur et dirigez-moi dans la bonne direction. Je vais leur montrer ce que le loup de l\'allée des arènes a à leur offrir !%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Le loup de l\'allée des arènes ? Ah, d\'accord.",
					function getResult( _event )
					{
						this.World.getPlayerRoster().add(_event.m.Dude);
						this.World.getTemporaryRoster().clear();
						_event.m.Dude.onHired();
						_event.m.Dude = null;
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Gladiator.getImagePath());
				local roster = this.World.getTemporaryRoster();
				_event.m.Dude = roster.create("scripts/entity/tactical/player");
				_event.m.Dude.setStartValuesEx([
					"old_gladiator_background"
				]);
				_event.m.Dude.setTitle("the Wolf");
				_event.m.Dude.getBackground().m.RawDescription = "%name%, également connu sous le nom de Le loup de l\'allée des arènes, est un gladiateur à la retraite, mais un mercenaire actif. Il gagne des couronnes en tuant depuis longtemps, et cela se voit tant dans son expérience que dans son âge.";
				_event.m.Dude.getBackground().buildDescription(true);
				local trait = this.new("scripts/skills/traits/old_trait");
				_event.m.Dude.getSkills().add(trait);
				this.Characters.push(_event.m.Dude.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "Deny",
			Text = "[img]gfx/ui/events/event_163.png[/img]{Le gladiateur se rassoit.%SPEECH_ON%Et bien, à quoi a servi ce grand discours de bravade ? %SPEECH_OFF%%gladiateur% s\'excuse, vous jetant un regard entre les mots tandis que le reste de la compagnie rit.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "désolé.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Gladiator.getImagePath());
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (this.Math.rand(1, 100) <= 50)
					{
						bro.improveMood(0.5, "J\'ai bien ri d\'un gladiateur à la retraite.");

						if (bro.getMoodState() > this.Const.MoodState.Neutral)
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
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Desert)
		{
			return;
		}

		if (this.World.Assets.getMoney() < 1250)
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();
		
		if (!this.World.Assets.getStash().hasEmptySlot())
		{
			return;
		}

		if (this.World.getPlayerRoster().getSize() >= this.World.Assets.getBrothersMax())
		{
			return;
		}

		local towns = this.World.EntityManager.getSettlements();
		local currentTile = this.World.State.getPlayer().getTile();

		foreach( t in towns )
		{
			if (t.isSouthern() && t.getTile().getDistanceTo(currentTile) <= 4 && t.isAlliedWithPlayer() && t.hasBuilding("building.arena"))
			{
				this.m.Town = t;
				break;
			}
		}

		if (this.m.Town == null)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.gladiator")
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() != 0)
		{
			this.m.Gladiator = candidates[this.Math.rand(0, candidates.len() - 1)];
		}

		this.m.Name = this.Const.Strings.SouthernNames[this.Math.rand(0, this.Const.Strings.SouthernNames.len() - 1)];
		this.m.Score = 15;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"gladiator",
			this.m.Gladiator != null ? this.m.Gladiator.getNameOnly() : ""
		]);
		_vars.push([
			"townname",
			this.m.Town.getName()
		]);
		_vars.push([
			"retired",
			this.m.Name
		]);
	}

	function onClear()
	{
		this.m.Town = null;
		this.m.Dude = null;
		this.m.Gladiator = null;
		this.m.Name = null;
	}

});

