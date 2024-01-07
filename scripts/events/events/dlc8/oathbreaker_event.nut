this.oathbreaker_event <- this.inherit("scripts/events/event", {
	m = {
		Dude = null
	},
	function create()
	{
		this.m.ID = "event.oathbreaker";
		this.m.Title = "Sur la route...";
		this.m.Cooldown = 999999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_180.png[/img]{Vous rencontrez un homme qui semble être en pleine confusion: d\'un côté, il est couvert d\'une armure ornée qui semble convenir à un homme assis sur un cheval prêt à effectuer une joute dans un grand tournoi. D\'autre part, il est étendu sur le sol, les jambes faisant des ciseaux d\'avant en arrière, ce qui traduit chez lui un état d\'ébriété avancé. Ses bras sont étendus comme s\'ils voulaient étreindre quelqu\'un ou quelque chose...%SPEECH_ON%Je ne suis plus enclin à suivre la voie martiale, je préférerais acheter mon chemin vers les grâces du jeune Anselm plutôt que de le faire à l\'épée. Que les anciens dieux me frappent sans délai pour l\'avoir crier haut et fort!%SPEECH_OFF%Il semble qu\'il offre ses armes et armures pour un prix de, si vous comprenez bien ses élucubrations, 9000 couronnes.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Nous prenons le tout pour 9 000 couronnes.",
					function getResult( _event )
					{
						return "BuyArmor";
					}

				},
				{
					Text = "Non merci.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				if (this.World.Assets.getOrigin().getID() == "scenario.paladins")
				{
					this.Options.push({
						Text = "Le jeune Anselm a d\'autres projets pour vous. Rejoignez-nous!",
						function getResult( _event )
						{
							return "Oathtaker";
						}

					});
				}
			}

		});
		this.m.Screens.push({
			ID = "BuyArmor",
			Text = "[img]gfx/ui/events/event_180.png[/img]{Vous vous avancez vers lui en tenant la bourse pleines de couronnes.%SPEECH_ON%Enlevez tout.%SPEECH_OFF%L\'homme acquiesce et commence à enlever l\'armure, à s\'en dégager, à renifler de temps en temps. Il tend le tout et l\'armure avec. Vous mettez l\'ensemble des objetss dans l\'inventaire, puis vous donnez l\'argent comme convenu. Ses doigts s\'agrippent et touchent a bourse comme les pattes d\'une araignée qui enroule sa proie, ses yeux ivres papillonnant de gauche à droite. Il se lève et s\'en va en clopinant. Vous avez le sentiment qu\'il ne trouvera pas la rédemption à laquelle il pense avec cet argent. %randombrother% pose une main sur votre épaule.%SPEECH_ON%Ne vous attardez pas sur lui, capitaine. Il y a certaines personnes dans ce monde qu\'il faut oublier le plus vite possible, compris?%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Bon voyage.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local item;
				local stash = this.World.Assets.getStash();
				local weapons = [
					"weapons/arming_sword",
					"weapons/military_pick",
					"weapons/hand_axe",
					"weapons/pike",
					"weapons/warbrand"
				];
				item = this.new("scripts/items/" + weapons[this.Math.rand(0, weapons.len() - 1)]);
				item.setCondition(item.getConditionMax() / 3 - 1);
				stash.add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "You gain " + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
				item = this.new("scripts/items/armor/adorned_heavy_mail_hauberk");
				item.setCondition(item.getConditionMax() / 3 - 1);
				stash.add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "You gain " + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
				item = this.new("scripts/items/helmets/adorned_full_helm");
				item.setCondition(item.getConditionMax() / 3 - 1);
				stash.add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "You gain " + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
				this.World.Assets.addMoney(-9000);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "You lose [color=" + this.Const.UI.Color.NegativeEventValue + "]9,000[/color] Crowns"
				});
			}

		});
		this.m.Screens.push({
			ID = "Oathtaker",
			Text = "[img]gfx/ui/events/event_183.png[/img]{Vous préférez lui tendre la main plutôt que de lui donner bêtement de l\'argent.%SPEECH_ON%Monsieur, le jeune Anselm savait très bien qu\'aucun serment ne pouvait être respecté éternellement. Echouer, c\'est vivre, et vivre, c\'est échouer. Pensez-vous qu\'être ici dans la boue est une erreur? Pensez-vous que vos échecs sont réparés grâce à l\'argent?%SPEECH_OFF%L\'homme lève les yeux. Il demande si vous aussi, vous connaissez le jeune Anselm. Il ne vous a toujours pas pris la main, alors vous prenez la sienne et le mettez debout.%SPEECH_ON%Oathtaker, qui m\'a envoyé selon vous?%SPEECH_OFF%L\'homme trébuche une seconde, vous regardant avec incrédulité. Puis il esquisse un large sourire et vous serre dans ses bras, vous embrassant ainsi que la compagnie. Un Oathtaker peut se trouver n\'importe où dans le monde, il ne sera jamais seul, tel était le premier message du Jeune Anselm.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Bienvenue à bord!",
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
				local roster = this.World.getTemporaryRoster();
				_event.m.Dude = roster.create("scripts/entity/tactical/player");
				_event.m.Dude.setStartValuesEx([
					"paladin_background"
				]);
				_event.m.Dude.setTitle("the Oathbreaker");
				_event.m.Dude.getBackground().m.RawDescription = "Comme beaucoup d'hommes, %name% a été trouvé dans la misère. De la bière sur ses lèvres, de la crasse dans ses oreilles, de l'urine et des excréments au moins quelque part sur lui. Mais il était un Gardien de Serments dans l'âme, et par la providence du jeune Anselm, ce n'était certainement pas une circonstance ordinaire qui l'a ramené à la foi. Bien sûr, il associera toujours la bière à la croyance, mais de temps en temps, on doit permettre à un homme ses vices, surtout si ledit homme partage un intérêt pour tuer les Porteurs de Serments."
				_event.m.Dude.getBackground().buildDescription(true);
				_event.m.Dude.m.PerkPoints = 0;
				_event.m.Dude.m.LevelUps = 0;
				_event.m.Dude.m.Level = 1;
				_event.m.Dude.m.XP = this.Const.LevelXP[_event.m.Dude.m.Level - 1];
				local trait = this.new("scripts/skills/traits/drunkard_trait");
				_event.m.Dude.getSkills().add(trait);
				local dudeItems = _event.m.Dude.getItems();

				if (dudeItems.getItemAtSlot(this.Const.ItemSlot.Mainhand) != null)
				{
					dudeItems.getItemAtSlot(this.Const.ItemSlot.Mainhand).removeSelf();
				}

				if (dudeItems.getItemAtSlot(this.Const.ItemSlot.Offhand) != null)
				{
					dudeItems.getItemAtSlot(this.Const.ItemSlot.Offhand).removeSelf();
				}

				if (dudeItems.getItemAtSlot(this.Const.ItemSlot.Head) != null)
				{
					dudeItems.getItemAtSlot(this.Const.ItemSlot.Head).removeSelf();
				}

				if (dudeItems.getItemAtSlot(this.Const.ItemSlot.Body) != null)
				{
					dudeItems.getItemAtSlot(this.Const.ItemSlot.Body).removeSelf();
				}

				local weapons = [
					"weapons/arming_sword",
					"weapons/military_pick",
					"weapons/hand_axe",
					"weapons/pike",
					"weapons/warbrand"
				];
				local item = this.new("scripts/items/" + weapons[this.Math.rand(0, weapons.len() - 1)]);
				item.setCondition(item.getConditionMax() / 3 - 1);
				dudeItems.equip(item);
				item = this.new("scripts/items/helmets/adorned_full_helm");
				item.setCondition(item.getConditionMax() / 3 - 1);
				dudeItems.equip(item);
				item = this.new("scripts/items/armor/adorned_heavy_mail_hauberk");
				item.setCondition(item.getConditionMax() / 3 - 1);
				dudeItems.equip(item);
				this.Characters.push(_event.m.Dude.getImagePath());
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Paladins)
		{
			return;
		}

		if (this.World.Assets.getMoney() < 10500)
		{
			return;
		}

		if (this.World.Assets.getStash().getNumberOfEmptySlots() < 3)
		{
			return;
		}

		if (this.World.Assets.getOrigin().getID() == "scenario.paladins" && this.World.getPlayerRoster().getSize() >= this.World.Assets.getBrothersMax())
		{
			return;
		}

		this.m.Score = 5;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
	}

	function onClear()
	{
		this.m.Dude = null;
	}

});

