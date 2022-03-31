this.undead_outro_event <- this.inherit("scripts/events/event", {
	m = {
		Dude = null
	},
	function create()
	{
		this.m.ID = "event.crisis.undead_outro";
		this.m.Title = "Sur la route...";
		this.m.Cooldown = 1.0 * this.World.getTime().SecondsPerDay;
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_33.png[/img]Vous faites une sieste.\n\n Noirceur. Ténèbres. Tout ce qu\'un rêve devrait être, à l\'exception d\'un petit fait : vous savez que vous y êtes. Debout dans le vide comme une pensée perdue. Une voix se fait entendre sur vous, dégoulinant de tous les côtés comme si vous étiez dans la bouche même qui l\'a produite.%SPEECH_ON%Pourquoi nous avez-vous abandonnés, Empereur ?%SPEECH_OFF%Vous tournez en rond, ou du moins pensez que vous le faites, car il y a il n\'y a rien autour de quoi fonder même le plus faible des mouvements.%SPEECH_ON%Vous m\'avez promis, ne vous en souvenez-vous pas ? Tu as dit que ce serait bien si tout s\'effondrait. Tu as dit que tu avais un plan, que tu avais passé un marché avec ce vilain, vilain homme. Que s\'est-il passé ?%SPEECH_OFF%",
			Image = "",
			Characters = [],
			Options = [
				{
					Text = "Je n\'étais pas l\'élu.",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "Reposez-vous, mon amour. Il n\'y a rien à craindre dans la mort.",
					function getResult( _event )
					{
						return "C";
					}

				},
				{
					Text = "Qui était l\'homme laid ?",
					function getResult( _event )
					{
						return "D";
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_33.png[/img]Vous élevez la voix.%SPEECH_ON%Je ne suis pas l\'élu.%SPEECH_OFF%Avant même que l\'admission ne soit claire, elle commence à sangloter. Ses mots éclatèrent à travers les pleurs comme une honnêteté hoquetée.%SPEECH_ON%Je-je sais... Je ne voulais pas l\'admettre, mais je sais. L\'Empire meurt avec nous. Sy\'leth daef\'nya, mon empereur.%SPEECH_OFF%\'Emperor\' résonne, plus faible à cause de la répétition, jusqu\'à ce que vous restiez dans l\'obscurité et le silence.",
			Image = "",
			Characters = [],
			Options = [
				{
					Text = "Réveille toi!",
					function getResult( _event )
					{
						return "E";
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_33.png[/img]Au début, tu ne dis rien. Elle commence à pleurer. Tu entends les larmes, chaque goutte se répercutant tout autour de toi.%SPEECH_ON%Êtes-vous là, mon Empereur ?%SPEECH_OFF%Vous vous raclez la gorge et répondez.%SPEECH_ON%Oui, je le suis. L\'Empire ne se relèvera pas. Nous devons partir. Il n\'y a rien à craindre dans la mort.%SPEECH_OFF%La femme pleure, mais se stabilise lentement.%SPEECH_ON%Je n\'ai pas peur. De l\'autre côté, ish\'nyarh ishe\'yarn, mon empereur.%SPEECH_OFF%Alors que ses paroles s\'effacent de votre esprit, tout ce qui vous reste est le silence.",
			Image = "",
			Characters = [],
			Options = [
				{
					Text = "Réveille toi!",
					function getResult( _event )
					{
						return "E";
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_33.png[/img]Vous vous retournez.%SPEECH_ON%Qui est l\'homme laid ?%SPEECH_OFF%La voix de la femme bégaie sous le choc.%SPEECH_ON%Vous, vous ne vous souvenez pas ?%SPEECH_OFF%En vous raclant la gorge, vous feignez l\'honnêteté de souvenirs perdus.%SPEECH_ON%Je ne me souviens de rien, mon amour.%SPEECH_OFF%Un grand soupir tombe sur l\'obscurité. Vous pouvez sentir sa frustration. Elle parle avec exaspération.%SPEECH_ON%Je savais qu\'on n\'aurait pas dû lui faire confiance... L\'homme laid est venu vers nous dans la nuit quand notre enfant est mort-né. Il a dit que s\'il pouvait prendre notre sang, ainsi que celui de notre enfant mort, il ferait en sorte que l\'Empire ne meure jamais, nous serions ses dirigeants éternels. Mais... ça a eu un coût.%SPEECH_OFF%Vous le comprenez rapidement et répondez.%SPEECH_ON%Il vous a rendu stérile.%SPEECH_OFF%La femme sanglote.%SPEECH_ON%Nous n\'aurions jamais dû lui faire confiance ! J\'aurai ce vilain homme ! N\'ayez aucun doute, kearem su\'llah. Je le traiterai pour l\'éternité, une éternité de douleur et de souffrance !%SPEECH_OFF%Le vide autrefois noir brille en rouge, clignotant sur un monde de couleur cramoisie et de férocité. Vous levez la main en protégeant vos yeux. Elle crie, perçant vos oreilles jusqu\'à ce que vous n\'entendiez qu\'un bourdonnement sourd.",
			Image = "",
			Characters = [],
			Options = [
				{
					Text = "Réveille toi!",
					function getResult( _event )
					{
						return "E";
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "E",
			Text = "[img]gfx/ui/events/event_33.png[/img]Vous vous réveillez. Un vent violent plie la tente, agitant le cuir et roulant une marée sur le plafond. La faible lueur des bougies scintille dans les ténèbres. %dude% se tient là, vous regardant, des ombres traversant sa poitrine. Il remue sur ses pieds, une expression mal à l\'aise sur le visage.%SPEECH_ON%À qui parliez-vous ?%SPEECH_OFF%Sortant du lit, vous posez vos bottes par terre, voulant être sûr de cette réalité avant d\'oser discuter avec lui. La saleté bruisse et craque sous vos pieds. Vous répondez.%SPEECH_ON%Je ne suis pas sûr. Je pense... Je pense que l\'invasion est terminée.%SPEECH_OFF%Le mercenaire hoche la tête et tourne la main vers l\'entrée de la tente.%SPEECH_ON%Oui, c\'est pourquoi je suis ici. Un noble messager est arrivé il y a une minute. Il dit que les morts-vivants ont cessé de sortir du sol. Les scribes croient que c\'est fini. Ça va, monsieur ?%SPEECH_OFF%Vous vous frottez la tête. Est-il temps de prendre votre retraite? Que pouvez-vous faire de ce monde maintenant que vous savez ce que vous faites ? Il s\'agit soit de passer le reste de vos jours en paix, soit de tout dire et d\'ordonner à %companyname% d\'aller plus loin dans la gloire.\n\n%OOC%Vous avez gagné ! Battle Brothers est conçu pour la rejouabilité et pour que les campagnes soient jouées jusqu\'à ce que vous ayez vaincu une ou deux crises de fin de partie. Lancer une nouvelle campagne vous permettra d\'essayer différentes choses dans un monde différent.\n\nVous pouvez également choisir de poursuivre votre campagne aussi longtemps que vous le souhaitez. Sachez simplement que les campagnes ne sont pas destinées à durer éternellement et que vous finirez probablement par manquer de défis.%OOC_OFF%",
			Image = "",
			Characters = [],
			Options = [
				{
					Text = "%companyname% ont besoin de leur commandant !",
					function getResult( _event )
					{
						return 0;
					}

				},
				{
					Text = "Il est temps de se retirer de la vie de mercenaire. (Fin de campagne)",
					function getResult( _event )
					{
						this.World.State.getMenuStack().pop(true);
						this.World.State.showGameFinishScreen(true);
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Dude.getImagePath());
				this.updateAchievement("BaneOfTheUndead", 1, 1);

				if (this.World.Assets.isIronman())
				{
					this.updateAchievement("ManOfIron", 1, 1);
				}

				if (this.World.Assets.isIronman())
				{
					local defeated = this.getPersistentStat("CrisesDefeatedOnIronman");
					defeated = defeated | this.Const.World.GreaterEvilTypeBit.Undead;
					this.setPersistentStat("CrisesDefeatedOnIronman", defeated);

					if (defeated == this.Const.World.GreaterEvilTypeBit.All)
					{
						this.updateAchievement("Savior", 1, 1);
					}
				}
			}

		});
	}

	function onUpdateScore()
	{
		if (this.World.getTime().IsDaytime)
		{
			return;
		}

		if (this.World.Statistics.hasNews("crisis_undead_end"))
		{
			local brothers = this.World.getPlayerRoster().getAll();
			local most_days_with_company = -9000.0;
			local most_days_with_company_bro;

			foreach( bro in brothers )
			{
				if (bro.getDaysWithCompany() > most_days_with_company)
				{
					most_days_with_company = bro.getDaysWithCompany();
					most_days_with_company_bro = bro;
				}
			}

			this.m.Dude = most_days_with_company_bro;
			this.m.Score = 6000;
		}
	}

	function onPrepare()
	{
		this.World.Statistics.popNews("crisis_undead_end");
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"dude",
			this.m.Dude.getNameOnly()
		]);
	}

	function onClear()
	{
		this.m.Dude = null;
	}

});

